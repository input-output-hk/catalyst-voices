//! Implementation of the GET `/rbac/registrations` endpoint.

pub(crate) use response::AllResponses;

mod purpose_list;
mod registration_chain;
mod response;
mod unprocessable_content;

// TODO: FIXME: Remove.
// mod cip509;
// mod rbac_reg;
// mod reg_chain;

use anyhow::{anyhow, bail, Context};
use cardano_blockchain_types::{Network, Point, Slot, StakeAddress, TxnIndex};
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
            response::Responses, unprocessable_content::RbacUnprocessableContent,
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
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    let catalyst_id = match lookup {
        Some(CatIdOrStake::CatId(v)) => v.into(),
        Some(CatIdOrStake::Address(address)) => {
            let address = match address.try_into() {
                Ok(a) => a,
                Err(e) => return AllResponses::handle_error(&e),
            };
            match catalyst_id_from_stake(&session, address).await {
                Ok(Some(v)) => v,
                Ok(None) => return Responses::NotFound.into(),
                Err(e) => return AllResponses::handle_error(&e),
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

    match registration_chain(&session, &catalyst_id).await {
        Ok(Some(c)) => Responses::Ok(Json(Box::new(c.into()))).into(),
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

/// Returns a registration chain for the given Catalyst ID.
async fn registration_chain(
    session: &CassandraSession, catalyst_id: &IdUri,
) -> anyhow::Result<Option<RegistrationChain>> {
    let indexed_registrations = indexed_registrations(session, catalyst_id).await?;
    let mut indexed_registrations = indexed_registrations.iter();
    let Some(root) = indexed_registrations.next() else {
        return Ok(None);
    };

    let network = Settings::cardano_network();
    let root = registration(network, root.slot_no.into(), root.txn_index.into())
        .await
        .context("Failed to get root registration")?;
    let mut chain = RegistrationChain::new(root).context("Invalid root registration")?;

    for reg in indexed_registrations {
        // We only store valid registrations in this table, so an error here indicates a bug in
        // our indexing logic.
        let cip509 = registration(network, reg.slot_no.into(), reg.txn_index.into())
            .await
            .with_context(|| {
                format!(
                    "Invalid or missing registration at {:?} block {:?} transaction",
                    reg.slot_no, reg.txn_index,
                )
            })?;
        match chain.update(cip509) {
            Ok(c) => chain = c,
            Err(_) => {
                // This isn't a hard error because while the individual registration can
                // be valid it can be invalid in the context of the whole registration
                // chain.
            },
        }
    }

    Ok(Some(chain))
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
