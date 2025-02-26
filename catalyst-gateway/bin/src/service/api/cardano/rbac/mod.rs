//! RBAC endpoints.

use poem_openapi::{param::Path, OpenApi};

use crate::service::common::{
    auth::none_or_rbac::NoneOrRBAC,
    objects::cardano::hash::Hash128,
    tags::ApiTags,
    types::cardano::{catalyst_id::CatalystId, cip19_stake_address::Cip19StakeAddress},
};

mod chain_root_get;
mod registrations_get;
mod role0_chain_root_get;

/// Cardano RBAC API Endpoints
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
    ) -> chain_root_get::AllResponses {
        chain_root_get::endpoint(stake_address).await
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
    ) -> registrations_get::AllResponses {
        registrations_get::endpoint(catalyst_id.into()).await
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
        &self, /// Role0 key to get the chain root for.
        Path(role0_key): Path<Hash128>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> role0_chain_root_get::AllResponses {
        role0_chain_root_get::endpoint(role0_key.to_string()).await
    }
}
