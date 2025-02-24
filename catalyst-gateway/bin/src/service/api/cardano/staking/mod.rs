//! Cardano Staking API Endpoints.

use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};

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
        assets_get::endpoint(stake_address.0, network.0, SlotNo::into_option(asat.0)).await
    }
}
