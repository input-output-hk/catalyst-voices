//! Implementation of the GET `/rbac/registrations` endpoint.

use std::collections::HashSet;

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

use anyhow::{anyhow, Context};
use cardano_blockchain_types::StakeAddress;
use catalyst_types::id_uri::IdUri;
use futures::{future::try_join, TryFutureExt, TryStreamExt};
use poem_openapi::payload::Json;
use tracing::error;

use crate::{
    db::index::{
        queries::rbac::get_catalyst_id_from_stake_address::{Query, QueryParams},
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
                cardano::query::cat_id_or_stake::CatIdOrStake,
                headers::retry_after::RetryAfterOption,
            },
        },
    },
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
        Some(CatIdOrStake::CatId(v)) => vec![v.into()],
        Some(CatIdOrStake::Address(address)) => {
            let address: StakeAddress = match address.try_into() {
                Ok(a) => a,
                Err(e) => return AllResponses::handle_error(&e),
            };
            match try_join(
                catalyst_ids_from_stake(&persistent_session, address.clone()),
                catalyst_ids_from_stake(&volatile_session, address),
            )
            .await
            {
                Err(e) => return AllResponses::handle_error(&e),
                Ok((mut ids, volatile_ids)) => {
                    ids.extend(volatile_ids);
                    if ids.is_empty() {
                        return Responses::NotFound.into();
                    }

                    // Remove potential duplicates.
                    let mut seen = HashSet::new();
                    ids.retain(|id| seen.insert(id));
                    ids
                },
            }
        },
        None => {
            match token {
                Some(token) => vec![token.catalyst_id().clone()],
                None => {
                    return Responses::UnprocessableContent(Json(RbacUnprocessableContent::new(
                        "Either lookup parameter or token must be provided",
                    )))
                    .into()
                },
            }
        },
    };

    match ChainInfo::new(&persistent_session, &volatile_session, &catalyst_id).await {
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

/// Returns a Catalyst ID for the given stake address.
async fn catalyst_ids_from_stake(
    session: &CassandraSession, address: StakeAddress,
) -> anyhow::Result<Vec<IdUri>> {
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
