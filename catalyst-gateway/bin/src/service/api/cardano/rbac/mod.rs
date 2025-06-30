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
        path = "/v1/rbac/registration",
        method = "get",
        operation_id = "rbacRegistrations"
    )]
    /// Get RBAC registrations
    ///
    /// This endpoint returns RBAC registrations by provided auth Catalyst Id credentials
    /// or by the `lookup` argument if provided.
    async fn rbac_registrations_get(
        &self,
        /// Stake address or Catalyst ID to get the RBAC registration for.
        Query(lookup): Query<Option<CatIdOrStake>>,
        /// No Authorization required, but Token permitted.
        auth: NoneOrRBAC,
    ) -> registrations_get::AllResponses {
        let token = auth.into();
        // `Box::pin` is used here because of the future size (`clippy::large_futures` lint).
        Box::pin(registrations_get::endpoint(lookup, token)).await
    }
}
