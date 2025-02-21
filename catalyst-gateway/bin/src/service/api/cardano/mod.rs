//! Cardano API endpoints
use poem_openapi::{param::Path, OpenApi};

use crate::service::common::{
    auth::none_or_rbac::NoneOrRBAC,
    tags::ApiTags,
    types::{
        cardano::{catalyst_id::CatalystId, cip19_stake_address::Cip19StakeAddress},
        generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
    },
};

pub(crate) mod cip36;
mod rbac;
// mod registration_get;
pub(crate) mod staking;

/// Cardano Follower API Endpoints
pub(crate) struct Api;

#[OpenApi(tag = "ApiTags::Cardano")]
impl Api {
    // TODO: "Chain root" was replaced by "Catalyst ID", so this endpoint needs to be updated
    // or removed.
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
    #[oai(
        path = "/draft/rbac/role0_chain_root/:role0_key",
        method = "get",
        operation_id = "rbacRole0KeyChainRoot"
    )]
    /// Get RBAC chain root for a given role0 key.
    ///
    /// This endpoint returns the RBAC certificate chain root for a given role 0 key.
    async fn rbac_role0_key_chain_root(
        &self,
        /// Role0 key to get the chain root for.
        #[oai(validator(min_length = 34, max_length = 34, pattern = "0x[0-9a-f]{32}"))]
        Path(role0_key): Path<String>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> rbac::role0_chain_root_get::AllResponses {
        rbac::role0_chain_root_get::endpoint(role0_key).await
    }
}

/// Cardano API Endpoints
pub(crate) type CardanoApi = (Api, staking::Api, cip36::Api);
