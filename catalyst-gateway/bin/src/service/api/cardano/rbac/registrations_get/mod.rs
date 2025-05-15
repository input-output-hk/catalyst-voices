//! Implementation of the GET `/rbac/registrations` endpoint.

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

use anyhow::anyhow;
use cardano_blockchain_types::StakeAddress;
use catalyst_types::catalyst_id::CatalystId;
use poem_openapi::payload::Json;
use tracing::error;

use crate::{
    db::index::session::CassandraSession,
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

    let catalyst_id = match lookup {
        Some(CatIdOrStake::CatId(v)) => v.into(),
        Some(CatIdOrStake::Address(address)) => {
            let address: StakeAddress = match address.try_into() {
                Ok(a) => a,
                Err(e) => return AllResponses::handle_error(&e),
            };
            // TODO: For now we want to select the latest registration (so query the volatile
            // database first), but ideally the logic should be more sophisticated. See the issue
            // for more details: https://github.com/input-output-hk/catalyst-voices/issues/2152
            match catalyst_id_from_stake(&volatile_session, address.clone()).await {
                Ok(Some(v)) => v,
                Err(e) => return AllResponses::handle_error(&e),
                Ok(None) => {
                    match catalyst_id_from_stake(&persistent_session, address).await {
                        Ok(Some(v)) => v,
                        Err(e) => return AllResponses::handle_error(&e),
                        Ok(None) => return Responses::NotFound.into(),
                    }
                },
            }
        },
        None => {
            match token {
                Some(token) => token.catalyst_id().clone(),
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
#[allow(clippy::unused_async)]
async fn catalyst_id_from_stake(
    _session: &CassandraSession, _address: StakeAddress,
) -> anyhow::Result<Option<CatalystId>> {
    // TODO: This function should be entirely removed as a part of https://github.com/input-output-hk/catalyst-voices/issues/2532
    Ok(None)
}
