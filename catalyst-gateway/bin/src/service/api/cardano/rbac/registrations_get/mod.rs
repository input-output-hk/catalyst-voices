//! Implementation of the GET `/rbac/registrations` endpoint.

use anyhow::Context;
pub use response::AllResponses;

mod binary_data;
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

use poem_openapi::payload::Json;

use crate::{
    rbac::{latest_rbac_chain, latest_rbac_chain_by_address, ChainInfo},
    service::{
        api::cardano::rbac::registrations_get::{
            registration_chain::RbacRegistrationChain, response::Responses,
            unprocessable_content::RbacUnprocessableContent,
        },
        common::{
            auth::rbac::token::CatalystRBACTokenV1,
            types::cardano::query::cat_id_or_stake::CatIdOrStake,
        },
    },
};

/// Get RBAC registration endpoint.
pub(crate) async fn endpoint(
    lookup: Option<CatIdOrStake>, token: Option<CatalystRBACTokenV1>,
) -> AllResponses {
    if lookup.is_none() && token.is_none() {
        return Responses::UnprocessableContent(Json(RbacUnprocessableContent::new(
            "Either lookup parameter or token must be provided",
        )))
        .into();
    }

    match chain_info(lookup, token).await {
        Err(e) => AllResponses::handle_error(&e),
        Ok(Some(info)) => {
            match RbacRegistrationChain::new(&info) {
                Ok(c) => Responses::Ok(Json(Box::new(c))).into(),
                Err(e) => AllResponses::handle_error(&e),
            }
        },
        Ok(None) => Responses::NotFound.into(),
    }
}

/// Returns a `ChainInfo` object using either a Catalyst ID or a stake address.
async fn chain_info(
    lookup: Option<CatIdOrStake>, token: Option<CatalystRBACTokenV1>,
) -> anyhow::Result<Option<ChainInfo>> {
    match lookup {
        Some(CatIdOrStake::CatId(id)) => latest_rbac_chain(&id.into()).await,
        Some(CatIdOrStake::Address(address)) => {
            let address = address.try_into().context("Invalid stake address")?;
            latest_rbac_chain_by_address(&address).await
        },
        None => {
            // This error is properly handled above and shouldn't occur here.
            let token = token.context("Either lookup parameter or token must be provided")?;
            latest_rbac_chain(token.catalyst_id()).await
        },
    }
}
