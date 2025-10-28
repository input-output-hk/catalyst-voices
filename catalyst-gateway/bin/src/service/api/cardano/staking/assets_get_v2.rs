//! An implementation of the GET `v2/cardano/assets` endpoint.

use anyhow::Context;
use poem_openapi::payload::Json;
use poem_openapi_derive::ApiResponse;

use crate::service::{
    api::cardano::staking::{
        assets_get,
        assets_get::{AllResponses, Responses},
    },
    common::{
        auth::{none_or_rbac::NoneOrRBAC, rbac::token::CatalystRBACTokenV1},
        objects::cardano::{network::Network, stake_info::FullStakeInfo},
        responses::WithErrorResponses,
        types::{
            cardano::{cip19_stake_address::Cip19StakeAddress, slot_no::SlotNo},
            generic::error_msg::ErrorMessage,
        },
    },
};

/// An endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum ResponsesV2 {
    /// ## Ok
    ///
    /// The amount of ADA staked by the queried stake address, as at the indicated slot.
    #[oai(status = 200)]
    Ok(Json<FullStakeInfo>),

    /// ## Not Found
    ///
    /// The queried stake address was not found at the requested slot number.
    #[oai(status = 404)]
    NotFound,

    /// Response for unprocessable content.
    #[oai(status = 422)]
    UnprocessableContent(Json<ErrorMessage>),
}

/// All responses.
pub type AllResponsesV2 = WithErrorResponses<ResponsesV2>;

/// Get Cardano assets V2 endpoint.
pub(crate) async fn endpoint(
    address: Option<Cip19StakeAddress>,
    network: Option<Network>,
    slot: Option<SlotNo>,
    auth: NoneOrRBAC,
) -> AllResponsesV2 {
    let token: Option<_> = auth.into();
    if address.is_none() && token.is_none() {
        return ResponsesV2::UnprocessableContent(Json(
            "Either stake address parameter or token must be provided"
                .to_string()
                .into(),
        ))
        .into();
    }

    let stake_address = match stake_address(address, token).await {
        Ok(Some(a)) => a,
        Ok(None) => return ResponsesV2::NotFound.into(),
        Err(e) => return AllResponsesV2::handle_error(&e),
    };

    assets_get::endpoint(stake_address, network, slot)
        .await
        .into()
}

/// Returns a stake address from provided parameters.
async fn stake_address(
    address: Option<Cip19StakeAddress>,
    token: Option<CatalystRBACTokenV1>,
) -> anyhow::Result<Option<Cip19StakeAddress>> {
    if let Some(address) = address {
        return Ok(Some(address));
    }

    if let Some(mut token) = token {
        // This should never fail as a valid RBAC token can only be constructed after building a
        // corresponding registration chain.
        let chain = token
            .reg_chain()
            .await?
            .context("Missing registration chain for token")?;
        // TODO: Handle multiple stake addresses!
        if let Some(a) = chain.stake_addresses().iter().next().cloned() {
            return Ok(Some(a.into()));
        }
    }

    Ok(None)
}

impl From<AllResponses> for AllResponsesV2 {
    fn from(value: AllResponses) -> Self {
        match value {
            AllResponses::With(r) => {
                match r {
                    Responses::Ok(v) => AllResponsesV2::With(ResponsesV2::Ok(v)),
                    Responses::NotFound => AllResponsesV2::With(ResponsesV2::NotFound),
                }
            },
            AllResponses::Error(e) => AllResponsesV2::Error(e),
        }
    }
}
