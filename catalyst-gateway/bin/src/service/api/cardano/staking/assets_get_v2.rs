//! An implementation of the GET `v2/cardano/assets` endpoint.

use std::collections::HashSet;

use anyhow::Context;
use futures::future::try_join_all;
use poem_openapi::payload::Json;
use poem_openapi_derive::ApiResponse;

use crate::service::{
    api::cardano::staking::assets_get::build_full_stake_info_response,
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

    let stake_addresses = match stake_addresses(address, token).await {
        Err(e) => return AllResponsesV2::handle_error(&e),
        Ok(addresses) => addresses,
    };
    let infos: Vec<_> = match try_join_all(
        stake_addresses
            .into_iter()
            .map(|a| build_full_stake_info_response(a, network.clone(), slot)),
    )
    .await
    {
        Err(e) => return AllResponsesV2::handle_error(&e),
        Ok(r) => r.into_iter().flatten().collect(),
    };

    let info = infos.into_iter().reduce(|mut acc, mut info| {
        acc.persistent.0.ada_amount = acc
            .persistent
            .0
            .ada_amount
            .saturating_add(info.persistent.0.ada_amount);
        acc.persistent.0.slot_number =
            std::cmp::max(acc.persistent.0.slot_number, info.persistent.0.slot_number);
        acc.persistent
            .0
            .assets
            .append(&mut info.persistent.0.assets);

        acc.volatile.0.ada_amount = acc
            .volatile
            .0
            .ada_amount
            .saturating_add(info.volatile.0.ada_amount);
        acc.volatile.0.slot_number =
            std::cmp::max(acc.volatile.0.slot_number, info.volatile.0.slot_number);
        acc.volatile.0.assets.append(&mut info.volatile.0.assets);

        acc
    });

    match info {
        Some(i) => ResponsesV2::Ok(Json(i)).into(),
        None => ResponsesV2::NotFound.into(),
    }
}

/// Returns a stake address from provided parameters.
async fn stake_addresses(
    address: Option<Cip19StakeAddress>,
    token: Option<CatalystRBACTokenV1>,
) -> anyhow::Result<HashSet<Cip19StakeAddress>> {
    if let Some(address) = address {
        return Ok([address].into());
    }

    if let Some(mut token) = token {
        // This should never fail as a valid RBAC token can only be constructed after building a
        // corresponding registration chain.
        let chain = token
            .reg_chain()
            .await?
            .context("Missing registration chain for token")?;
        Ok(chain
            .stake_addresses()
            .into_iter()
            .map(Into::into)
            .collect())
    } else {
        Ok(HashSet::new())
    }
}
