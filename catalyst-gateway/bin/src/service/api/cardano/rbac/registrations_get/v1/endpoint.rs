//! Implementation of the GET `/rbac/registrations` V1 endpoint.

use anyhow::Context;
use poem_openapi::payload::Json;

use crate::{
    db::index::session::CassandraSession,
    rbac::{latest_rbac_chain, ChainInfo},
    service::{
        api::cardano::rbac::registrations_get::{
            unprocessable_content::RbacUnprocessableContent,
            v1::{
                registration_chain::RbacRegistrationChain,
                response::{AllResponsesV1, ResponsesV1},
            },
        },
        common::{
            auth::rbac::token::CatalystRBACTokenV1,
            types::cardano::query::cat_id_or_stake::CatIdOrStake,
        },
    },
};

/// Get RBAC registration V1 endpoint.
pub async fn endpoint_v1(
    lookup: Option<CatIdOrStake>,
    token: Option<CatalystRBACTokenV1>,
) -> AllResponsesV1 {
    if lookup.is_none() && token.is_none() {
        return ResponsesV1::UnprocessableContent(Json(RbacUnprocessableContent::new(
            "Either lookup parameter or token must be provided",
        )))
        .into();
    }

    // Box::pin is used here because of the future size (`clippy::large_futures` lint).
    match Box::pin(chain_info(lookup, token)).await {
        Err(e) => AllResponsesV1::handle_error(&e),
        Ok(Some(info)) => {
            match RbacRegistrationChain::new(&info) {
                Ok(c) => ResponsesV1::Ok(Json(Box::new(c))).into(),
                Err(e) => AllResponsesV1::handle_error(&e),
            }
        },
        Ok(None) => ResponsesV1::NotFound.into(),
    }
}

/// Returns a `ChainInfo` object using either a Catalyst ID or a stake address.
async fn chain_info(
    lookup: Option<CatIdOrStake>,
    token: Option<CatalystRBACTokenV1>,
) -> anyhow::Result<Option<ChainInfo>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_stake_address::Query;

    match lookup {
        Some(CatIdOrStake::CatId(id)) => latest_rbac_chain(&id.into()).await,
        Some(CatIdOrStake::Address(address)) => {
            let address = address.try_into().context("Invalid stake address")?;
            let volatile_session =
                CassandraSession::get(false).context("Failed to get volatile Cassandra session")?;
            let id = if let Some(id) = Query::latest(&volatile_session, &address).await? {
                id
            } else {
                let persistent_session = CassandraSession::get(true)
                    .context("Failed to get persistent Cassandra session")?;
                match Query::latest(&persistent_session, &address).await? {
                    Some(id) => id,
                    None => return Ok(None),
                }
            };
            latest_rbac_chain(&id).await
        },
        None => {
            // This error is properly handled above and shouldn't occur here.
            let token = token.context("Either lookup parameter or token must be provided")?;
            latest_rbac_chain(token.catalyst_id()).await
        },
    }
}
