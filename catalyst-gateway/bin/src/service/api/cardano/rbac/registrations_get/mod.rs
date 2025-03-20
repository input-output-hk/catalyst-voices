//! Implementation of the GET `/rbac/registrations` endpoint.

pub(crate) use response::AllResponses;

mod key_data;
mod payment_data;
mod purpose_list;
mod registration_chain;
mod response;
mod role_data;
mod unprocessable_content;

use anyhow::{anyhow, bail, Context};
use cardano_blockchain_types::{Network, Point, Slot, StakeAddress, TransactionId, TxnIndex};
use cardano_chain_follower::ChainFollower;
use catalyst_types::id_uri::IdUri;
use futures::{StreamExt, TryFutureExt, TryStreamExt};
use poem_openapi::payload::Json;
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::{
            get_catalyst_id_from_stake_address::{
                Query as CatalystIdQuery, QueryParams as CatalystIdQueryParams,
            },
            get_rbac_registrations::{Query as RbacQuery, QueryParams as RbacQueryParams},
        },
        session::CassandraSession,
    },
    service::{
        api::cardano::rbac::registrations_get::{
            registration_chain::RbacRegistrationChain, response::Responses,
            unprocessable_content::RbacUnprocessableContent,
        },
        common::types::{
            cardano::query::cat_id_or_stake::CatIdOrStake, headers::retry_after::RetryAfterOption,
        },
    },
    settings::Settings,
};

/// Get RBAC registration endpoint.
pub(crate) async fn endpoint(
    lookup: Option<CatIdOrStake>, auth_catalyst_id: Option<IdUri>,
) -> AllResponses {
    let Some(persistent_session) = CassandraSession::get(true) else {
        let err = anyhow!("Failed to acquire persistent db session");
        error!("{err:?}");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };
    let Some(volatile_session) = CassandraSession::get(false) else {
        let err = anyhow!("Failed to acquire volatile db session");
        error!("{err:?}");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    let catalyst_id = match lookup {
        Some(CatIdOrStake::CatId(v)) => v.into(),
        Some(CatIdOrStake::Address(address)) => {
            let address: StakeAddress = match address.try_into() {
                Ok(a) => a,
                Err(e) => return AllResponses::handle_error(&e),
            };
            match catalyst_id_from_stake(&persistent_session, address.clone()).await {
                Ok(Some(v)) => v,
                Err(e) => return AllResponses::handle_error(&e),
                Ok(None) => {
                    match catalyst_id_from_stake(&volatile_session, address).await {
                        Ok(Some(v)) => v,
                        Err(e) => return AllResponses::handle_error(&e),
                        Ok(None) => return Responses::NotFound.into(),
                    }
                },
            }
        },
        None => {
            match auth_catalyst_id {
                Some(id) => id,
                None => {
                    return Responses::UnprocessableContent(Json(RbacUnprocessableContent::new(
                        "Either lookup parameter or token must be provided",
                    )))
                    .into()
                },
            }
        },
    };

    match registration_chain(&persistent_session, &volatile_session, &catalyst_id).await {
        Ok(Some((c, persistent_id, volatile_id))) => {
            Responses::Ok(Json(Box::new(RbacRegistrationChain::new(
                c,
                persistent_id,
                volatile_id,
            ))))
            .into()
        },
        Ok(None) => Responses::NotFound.into(),
        Err(e) => AllResponses::handle_error(&e),
    }
}

/// Returns a Catalyst ID for the given stake address.
async fn catalyst_id_from_stake(
    session: &CassandraSession, address: StakeAddress,
) -> anyhow::Result<Option<IdUri>> {
    let mut iter = CatalystIdQuery::execute(session, CatalystIdQueryParams {
        stake_address: address.into(),
    })
    .await
    .context("Failed to query Catalyst ID from stake address {e:?}")?;

    match iter.next().await {
        Some(Ok(v)) => Ok(Some(v.catalyst_id.into())),
        Some(Err(e)) => {
            Err(anyhow!(
                "Failed to query Catalyst ID from stake address {e:?}"
            ))
        },
        None => Ok(None),
    }
}

/// Returns a registration chain and optional transaction IDs of the latest persistent and
/// volatile registrations.
async fn registration_chain(
    persistent_session: &CassandraSession, volatile_session: &CassandraSession, catalyst_id: &IdUri,
) -> anyhow::Result<
    Option<(
        RegistrationChain,
        Option<TransactionId>,
        Option<TransactionId>,
    )>,
> {
    let persistent_registrations = indexed_registrations(persistent_session, catalyst_id).await?;
    let volatile_registrations = indexed_registrations(volatile_session, catalyst_id).await?;
    let network = Settings::cardano_network();

    let chain = apply_registrations(network, None, persistent_registrations).await?;
    let persistent_id = chain.as_ref().map(|c| c.current_tx_id_hash());
    let chain = apply_registrations(network, chain, volatile_registrations).await?;
    let volatile_id = chain.as_ref().map(|c| c.current_tx_id_hash());

    Ok(chain.map(|c| (c, persistent_id, volatile_id)))
}

/// Returns a sorted list of all registrations for the given Catalyst ID from the
/// database.
async fn indexed_registrations(
    session: &CassandraSession, catalyst_id: &IdUri,
) -> anyhow::Result<Vec<RbacQuery>> {
    let mut result: Vec<_> = RbacQuery::execute(&session, RbacQueryParams {
        catalyst_id: catalyst_id.clone().into(),
    })
    .and_then(|r| r.try_collect().map_err(Into::into))
    .await?;

    result.sort_by_key(|r| r.slot_no);
    Ok(result)
}

/// Applies the given list of indexed registrations to the chain. If the given chain is
/// `None` - new root will be possibly created.
async fn apply_registrations(
    network: Network, mut chain: Option<RegistrationChain>, indexed_registrations: Vec<RbacQuery>,
) -> anyhow::Result<Option<RegistrationChain>> {
    for reg in indexed_registrations {
        // We perform validation during indexing, so this normally should never fail.
        let cip509 = registration(network, reg.slot_no.into(), reg.txn_index.into())
            .await
            .with_context(|| {
                format!(
                    "Failed to get Cip509 registration from {:?} slot and {:?} txn index",
                    reg.slot_no, reg.txn_index
                )
            })?;

        match chain {
            None => {
                if let Ok(root) = RegistrationChain::new(cip509) {
                    chain = Some(root);
                }
            },
            Some(ref current) => {
                // This isn't a hard error because while the individual registration can
                // be valid it can be invalid in the context of the whole registration
                // chain.
                if let Ok(new) = current.update(cip509) {
                    chain = Some(new);
                }
            },
        }
    }

    Ok(chain)
}

/// Returns a RBAC registration from the given block and slot.
async fn registration(network: Network, slot: Slot, txn_index: TxnIndex) -> anyhow::Result<Cip509> {
    let point = Point::fuzzy(slot);
    let block = ChainFollower::get_block(network, point)
        .await
        .context("Unable to get block")?
        .data;
    if block.point().slot_or_default() != slot {
        // The `ChainFollower::get_block` function can return the next consecutive block if it
        // cannot find the exact one. This shouldn't happen, but we need to check anyway.
        bail!("Unable to find exact block");
    }
    Cip509::new(&block, txn_index, &[])
        .context("Invalid RBAC registration")?
        .context("No RBAC registration at this block and txn index")
}
