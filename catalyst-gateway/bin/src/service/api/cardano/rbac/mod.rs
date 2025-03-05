//! RBAC endpoints.

use poem_openapi::{param::Query, OpenApi};

use crate::service::common::{
    auth::none_or_rbac::NoneOrRBAC, tags::ApiTags,
    types::cardano::query::cat_id_or_stake::CatIdOrStake,
};

mod registrations_get;

/// Cardano RBAC API Endpoints
pub(crate) struct Api;

#[OpenApi(tag = "ApiTags::Cardano")]
impl Api {
    #[oai(
        path = "/draft/rbac/registration",
        method = "get",
        operation_id = "rbacRegistrations"
    )]
    /// Get RBAC registrations
    ///
    /// This endpoint returns RBAC registrations by provided auth Catalyst Id credentials
    /// or by the `lookup` argument if provided.
    async fn rbac_registrations_get(
        &self,
        /// Stake address to get the RBAC registration for.
        Query(lookup): Query<Option<CatIdOrStake>>,
        /// A flag which enables returning all corresponded Cip509 registrations
        Query(detailed): Query<Option<bool>>,
        /// No Authorization required, but Token permitted.
        auth: NoneOrRBAC,
    ) -> registrations_get::AllResponses {
        let detailed = detailed.unwrap_or_default();
        let auth_catalyst_id = auth.into();
        registrations_get::endpoint(lookup, auth_catalyst_id, detailed).await
    }
}
