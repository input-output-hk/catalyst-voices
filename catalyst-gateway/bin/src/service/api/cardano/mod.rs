//! Cardano API endpoints

use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};

use crate::service::{
    api::cardano::types::DateTime,
    common::{
        auth::none_or_rbac::NoneOrRBAC,
        objects::cardano::network::Network,
        tags::ApiTags,
        types::{
            cardano::{catalyst_id::CatalystId, cip19_stake_address::Cip19StakeAddress},
            generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
        },
    },
    utilities::middleware::schema_validation::schema_version_validation,
};

pub(crate) mod cip36;
mod date_time_to_slot_number_get;
mod rbac;
// mod registration_get;
pub(crate) mod staking;
pub(crate) mod types;

/// Cardano Follower API Endpoints
pub(crate) struct Api;

#[OpenApi(tag = "ApiTags::Cardano")]
impl Api {
    /// Get Cardano slot to the provided date-time.
    ///
    /// This endpoint returns the closest cardano slot info to the provided
    /// date-time.
    #[oai(
        path = "/draft/cardano/date_time_to_slot_number",
        method = "get",
        operation_id = "dateTimeToSlotNumberGet",
        transform = "schema_version_validation"
    )]
    async fn date_time_to_slot_number_get(
        &self,
        /// The date-time for which the slot number should be calculated.
        /// If omitted current date time is used.
        date_time: Query<Option<DateTime>>,
        /// Cardano network type.
        /// If omitted `mainnet` network type is defined.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> date_time_to_slot_number_get::AllResponses {
        date_time_to_slot_number_get::endpoint(date_time.0, network.0).await
    }

    #[oai(
        path = "/draft/rbac/chain_root/:stake_address",
        method = "get",
        operation_id = "rbacChainRootGet"
    )]
    /// Get RBAC chain root
    ///
    /// This endpoint returns the RBAC certificate chain root for a given stake address.
    async fn rbac_chain_root_get(
        &self,
        /// Stake address to get the chain root for.
        Path(stake_address): Path<Cip19StakeAddress>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> rbac::chain_root_get::AllResponses {
        // TODO: "Chain root" was replaced by "Catalyst ID", so this endpoint needs to be updated
        // or removed.
        rbac::chain_root_get::endpoint(stake_address).await
    }

    #[oai(
        path = "/draft/rbac/registrations/:catalyst_id",
        method = "get",
        operation_id = "rbacRegistrations"
    )]
    /// Get registrations by Catalyst short ID.
    ///
    /// This endpoint returns RBAC registrations for the given Catalyst short identifier.
    async fn rbac_registrations_get(
        &self,
        /// A Catalyst short ID to get the registrations for.
        Path(catalyst_id): Path<CatalystId>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> rbac::registrations_get::AllResponses {
        rbac::registrations_get::endpoint(catalyst_id.into()).await
    }

    // TODO: "Chain root" was replaced by "Catalyst ID", so this endpoint needs to be updated
    // or removed.
    // #[oai(
    //     path = "/draft/rbac/role0_chain_root/:role0_key",
    //     method = "get",
    //     operation_id = "rbacRole0KeyChainRoot"
    // )]
    // /// Get RBAC chain root for a given role0 key.
    // ///
    // /// This endpoint returns the RBAC certificate chain root for a given role 0 key.
    // async fn rbac_role0_key_chain_root(
    //     &self,
    //     /// Role0 key to get the chain root for.
    //     #[oai(validator(min_length = 34, max_length = 34, pattern = "0x[0-9a-f]{32}"))]
    //     Path(_role0_key): Path<String>,
    //     /// No Authorization required, but Token permitted.
    //     _auth: NoneOrRBAC,
    // ) -> rbac::chain_root_get::AllResponses {
    //     rbac::chain_root_get::AllResponses::internal_error(&anyhow::anyhow!("Removed"))
    // }
}

/// Cardano API Endpoints
pub(crate) type CardanoApi = (Api, staking::Api, cip36::Api);
