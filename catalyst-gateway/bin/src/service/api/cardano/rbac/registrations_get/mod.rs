//! Implementation of the GET `/rbac/registrations` endpoint.

pub use response::AllResponses;

mod binary_data;
mod chain_info;
mod key_data;
mod payment_data;
mod purpose_list;
mod registration_chain;
mod response;
mod role_data;
mod unprocessable_content;

use anyhow::{anyhow, Context};
use cardano_blockchain_types::StakeAddress;
use catalyst_types::id_uri::IdUri;
use futures::StreamExt;
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
        common::types::{
            cardano::query::cat_id_or_stake::CatIdOrStake, headers::retry_after::RetryAfterOption,
        },
    },
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
async fn catalyst_id_from_stake(
    session: &CassandraSession, address: StakeAddress,
) -> anyhow::Result<Option<IdUri>> {
    let mut iter = Query::execute(session, QueryParams {
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
