//! RBAC endpoints.

use poem_openapi::{param::Query, OpenApi};

use crate::service::common::{
    auth::none_or_rbac::NoneOrRBAC, tags::ApiTags,
    types::cardano::query::stake_or_voter::StakeOrVoter,
};

mod rbac_registration;
mod registrations_get;
mod unprocessable_content;

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
        /// Stake address to get the RBACE registration for.
        Query(lookup): Query<Option<StakeOrVoter>>,
        /// A flag which enalbes returning all corresponded Cip509 registrations
        Query(detailed): Query<Option<bool>>,
        /// No Authorization required, but Token permitted.
        auth: NoneOrRBAC,
    ) -> registrations_get::AllResponses {
        let detailed = detailed.unwrap_or_default();
        let auth_catalyst_id = auth.into();
        registrations_get::endpoint(lookup, auth_catalyst_id, detailed).await
    }
}
