//! Implementation of the GET `/rbac/registrations` endpoint.

use std::collections::{HashMap, HashSet};

pub use response::AllResponses;

mod binary_data;
mod chain_info;
mod extended_data;
mod key_data;
mod key_data_list;
mod key_type;
mod payment_data;
mod payment_data_list;
mod purpose_list;
mod registration_chain;
mod response;
mod role_data;
mod role_map;
mod unprocessable_content;

use anyhow::{anyhow, bail, Context};
use cardano_blockchain_types::{Slot, StakeAddress, TransactionId};
use catalyst_types::id_uri::IdUri;
use futures::{
    future::{try_join, try_join_all},
    TryFutureExt, TryStreamExt,
};
use poem_openapi::payload::Json;
use rbac_registration::{cardano::cip509::RoleNumber, registration::cardano::RegistrationChain};
use tracing::{debug, error};

use crate::{
    db::index::{
        queries::rbac::{
            get_catalyst_id_from_stake_address::{Query, QueryParams},
            get_rbac_registrations,
            get_rbac_registrations::{indexed_registrations, load_cip509_from_chain},
        },
        session::CassandraSession,
    },
    service::{
        api::cardano::rbac::registrations_get::{
            chain_info::ChainInfo, registration_chain::RbacRegistrationChain, response::Responses,
            unprocessable_content::RbacUnprocessableContent,
        },
        common::{
            auth::rbac::token::CatalystRBACTokenV1,
            types::{
                cardano::{
                    cip19_stake_address::Cip19StakeAddress, query::cat_id_or_stake::CatIdOrStake,
                },
                headers::retry_after::RetryAfterOption,
            },
        },
    },
    settings::Settings,
};

/// Get RBAC registration endpoint.
pub(crate) async fn endpoint(
    lookup: Option<CatIdOrStake>, token: Option<CatalystRBACTokenV1>,
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

    let catalyst_ids = match lookup {
        Some(CatIdOrStake::CatId(v)) => HashSet::from([IdUri::from(v)]),
        Some(CatIdOrStake::Address(address)) => {
            match all_catalyst_ids(&persistent_session, &volatile_session, address).await {
                Ok(ids) => ids,
                Err(e) => return AllResponses::handle_error(&e),
            }
        },
        None => {
            match token {
                Some(token) => HashSet::from([token.catalyst_id().clone()]),
                None => {
                    return Responses::UnprocessableContent(Json(RbacUnprocessableContent::new(
                        "Either lookup parameter or token must be provided",
                    )))
                    .into()
                },
            }
        },
    };

    if catalyst_ids.is_empty() {
        return Responses::NotFound.into();
    }

    match process_registrations(&persistent_session, &volatile_session, catalyst_ids).await {
        Ok(Some(info)) => {
            match RbacRegistrationChain::new(&info) {
                Ok(c) => Responses::Ok(Json(Box::new(c))).into(),
                Err(e) => AllResponses::handle_error(&e),
            }
        },
        Ok(None) => Responses::NotFound.into(),
        Err(e) => AllResponses::handle_error(&e),
    }
}

/// Returns all Catalyst IDs from both persistent and volatile databases for the given
/// stake address.
async fn all_catalyst_ids(
    persistent_session: &CassandraSession, volatile_session: &CassandraSession,
    address: Cip19StakeAddress,
) -> anyhow::Result<HashSet<IdUri>> {
    let address: StakeAddress = address.try_into()?;

    try_join(
        catalyst_ids(&persistent_session, address.clone()),
        catalyst_ids(&volatile_session, address),
    )
    .await
    .map(|(mut p, v)| {
        p.extend(v);
        p
    })
}

/// Returns Catalyst IDs for the given stake address using the given database session.
async fn catalyst_ids(
    session: &CassandraSession, address: StakeAddress,
) -> anyhow::Result<HashSet<IdUri>> {
    Query::execute(session, QueryParams {
        stake_address: address.into(),
    })
    .and_then(|r| {
        r.map_ok(|v| v.catalyst_id.into())
            .try_collect()
            .map_err(Into::into)
    })
    .await
    .context("Failed to query Catalyst ID from stake address")
}

/// Processes registrations with the given set of Catalyst IDs and returns a single valid
/// registration chain if it exists.
async fn process_registrations(
    persistent_session: &CassandraSession, volatile_session: &CassandraSession,
    catalyst_ids: HashSet<IdUri>,
) -> anyhow::Result<Option<ChainInfo>> {
    let mut registrations: Vec<_> = try_join_all(
        catalyst_ids
            .iter()
            .map(|id| all_registrations(&persistent_session, &volatile_session, id)),
    )
    .await
    .map(|res| {
        let mut res: Vec<_> = res.into_iter().flatten().collect();
        // We need to sort using both a slot number and a transaction index because while it isn't
        // allowed to have multiple transactions from one RBAC chain in ona block, it is still
        // possible to have multiple transactions from several different chains that still share
        // the same stake address.
        res.sort_by(|a, b| {
            (a.query.slot_no, a.query.txn_index).cmp(&(b.query.slot_no, b.query.txn_index))
        });
        res
    })?;

    let network = Settings::cardano_network();

    // This map is used to discard registrations that contain a stake address that is already
    // used by previous registrations.
    let mut active_stake_addresses = HashMap::new();
    let mut chains: HashMap<IdUri, ChainInfo> = HashMap::new();

    for reg in registrations {
        let Ok(cip509) = load_cip509_from_chain(
            network,
            reg.query.slot_no.into(),
            reg.query.txn_index.into(),
        )
        .await
        else {
            // This shouldn't happen because we decode CIP509 during indexing. Ignoring an error
            // here is ok anyway.
            continue;
        };

        match chains.get_mut(&reg.catalyst_id) {
            Some(info) => {
                if cip509.role_data(RoleNumber::ROLE_0).is_some() {
                    // If there is an update to role 0 we need to check stake addresses.
                    // TODO: FIXME: Get addresses from Cip509.
                    // TODO: FIXME: It is never allowed to "reuse" active stake addresses
                    // in the update.
                }

                let Ok(new_chain) = info.chain.update(cip509) else {
                    continue;
                };
                info.chain = new_chain;
                if reg.is_persistent {
                    info.last_persistent_txn = Some(reg.query.txn_id.into());
                    info.last_persistent_slot = reg.query.slot_no.into();
                } else {
                    info.last_volatile_txn = Some(reg.query.txn_id.into());
                }
                // TODO: FIXME: Add a new stake addresses if needed.
            },
            None => {
                // A new root registration.
                let Ok(chain) = RegistrationChain::new(cip509) else {
                    // Same as above: just ignore a very unlikely error.
                    continue;
                };
                let stake_addresses = chain.role_0_stake_addresses();
                let intersection: Vec<_> = active_stake_addresses
                    .intersection(&stake_addresses)
                    .collect();
                // TODO: FIXME: It is allowed to restart a chain but only we the new one uses a
                // different public key from the last update of the old chain.

                // if !intersection.is_empty() {
                //     debug!("Ignoring RBAC registration from {:?} block, {:?} transaction index,
                // {} Catalyst ID, because {:?} stake addresses are already in use",
                //         reg.query.slot_no, reg.query.txn_index, reg.catalyst_id, intersection);
                //     continue;
                // }

                let mut last_persistent_txn = None;
                let mut last_volatile_txn = None;
                let mut last_persistent_slot = 0.into();
                if reg.is_persistent {
                    last_persistent_txn = Some(reg.query.txn_id.into());
                    last_persistent_slot = reg.query.slot_no.into();
                } else {
                    last_volatile_txn = Some(reg.query.txn_id.into());
                };
                chains.insert(reg.catalyst_id, ChainInfo {
                    chain,
                    last_persistent_txn,
                    last_volatile_txn,
                    last_persistent_slot,
                });
                active_stake_addresses
                    .extend(stake_addresses.into_iter().map(|a| (a, reg.catalyst_id)));
            },
        }
    }

    // There must be only one entry in the map if a user passed a Catalyst ID, but in case of
    // a stake address there can still be multiple entries. In that case we need to find a
    // chain that still uses the given stake address.
    if chains.is_empty() {
        Ok(None)
    } else if chains.len() == 1 {
        let (_, chain_info) = chains
            .into_iter()
            .next()
            // Should never happen because of the check above.
            .context("Unexpected chains length")?;
        Ok(Some(chain_info))
    } else {
        // TODO: FIXME:
        // Iterate over map and check the last address of every chain
        todo!()
    }
}

// TODO: FIXME: Move to a separate file.
/// An information about an indexed RBAC registration.
struct RegistrationInfo {
    pub catalyst_id: IdUri,
    pub is_persistent: bool,
    pub query: get_rbac_registrations::Query,
}

/// Returns an information for all persistent and volatile registrations with the given
/// Catalyst ID.
async fn all_registrations(
    persistent_session: &CassandraSession, volatile_session: &CassandraSession, catalyst_id: &IdUri,
) -> anyhow::Result<Vec<RegistrationInfo>> {
    let (persistent_registrations, volatile_registrations) = try_join(
        indexed_registrations(persistent_session, catalyst_id),
        indexed_registrations(volatile_session, catalyst_id),
    )
    .await?;

    Ok(persistent_registrations
        .into_iter()
        .map(|q| (true, q))
        .chain(volatile_registrations.into_iter().map(|q| (false, q)))
        .map(|(is_persistent, query)| {
            RegistrationInfo {
                catalyst_id: catalyst_id.clone(),
                is_persistent,
                query,
            }
        })
        .collect())
}
