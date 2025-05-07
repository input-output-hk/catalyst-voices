//! Cardano Staking API Endpoints.

use assets_get::{get_stake_address_from_cat_id, Responses};
use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};
use tracing::debug;

use crate::service::{
    common::{
        auth::none_or_rbac::NoneOrRBAC,
        objects::cardano::network::Network,
        tags::ApiTags,
        types::cardano::{self, cip19_stake_address::Cip19StakeAddress, slot_no::SlotNo},
    },
    utilities::middleware::schema_validation::schema_version_validation,
};

mod assets_get;

/// Cardano Staking API Endpoints
pub(crate) struct Api;

#[OpenApi(tag = "ApiTags::Cardano")]
impl Api {
    /// Get staked assets.
    ///
    /// This endpoint returns the total Cardano's staked assets to the corresponded
    /// user's stake address.
    #[oai(
        path = "/v1/cardano/assets/:stake_address",
        method = "get",
        operation_id = "stakedAssetsGet",
        transform = "schema_version_validation"
    )]
    async fn staked_ada_get(
        &self,
        /// The stake address of the user.
        /// Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
        stake_address: Path<Cip19StakeAddress>,
        /// Cardano network type.
        /// If omitted network type is identified from the stake address.
        /// If specified it must be correspondent to the network type encoded in the stake
        /// address.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
        /// A time point at which the assets should be calculated.
        /// If omitted latest slot number is used.
        asat: Query<Option<cardano::query::AsAt>>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> assets_get::AllResponses {
        Box::pin(assets_get::endpoint(
            stake_address.0,
            network.0,
            SlotNo::into_option(asat.0),
        ))
        .await
    }

    /// Get staked assets v2.
    ///
    /// This endpoint returns the total Cardano's staked assets to the corresponded
    /// user's stake address.
    #[oai(
        path = "/v2/cardano/assets/",
        method = "get",
        operation_id = "stakedAssetsGet",
        transform = "schema_version_validation"
    )]
    async fn staked_ada_get_v2(
        &self,
        /// The stake address of the user.
        /// Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
        stake_address: Query<Option<Cip19StakeAddress>>,
        /// Cardano network type.
        /// If omitted network type is identified from the stake address.
        /// If specified it must be correspondent to the network type encoded in the stake
        /// address.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
        /// A time point at which the assets should be calculated.
        /// If omitted latest slot number is used.
        asat: Query<Option<cardano::query::AsAt>>,
        /// No Authorization required, but Token permitted.
        auth: NoneOrRBAC,
    ) -> assets_get::AllResponses {
        let stake_address = match stake_address.0 {
            Some(addr) => addr,
            None => {
                if let NoneOrRBAC::RBAC(token) = auth {
                    match get_stake_address_from_cat_id(token.into()).await {
                        Ok(addr) => addr,
                        Err(err) => {
                            debug!("Cannot obtain stake addr from cat id {err}");
                            return Responses::NotFound.into();
                        },
                    }
                } else {
                    debug!("No Stake address or RBAC token present");
                    return Responses::NotFound.into();
                }
            },
        };

        Box::pin(assets_get::endpoint(
            stake_address,
            network.0,
            SlotNo::into_option(asat.0),
        ))
        .await
    }
}
