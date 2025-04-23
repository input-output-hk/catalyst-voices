//! RBAC endpoints.

use poem_openapi::{param::Query, payload::Json, OpenApi};

use crate::service::common::{
    auth::{
        api_key::InternalApiKeyAuthorization, none_or_rbac::NoneOrRBAC,
        rbac::token::CatalystRBACTokenV1,
    },
    tags::ApiTags,
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
        registrations_get::endpoint(lookup, token).await
    }

    #[oai(
        path = "/v1/rbac/token/validate",
        method = "post",
        operation_id = "rbacTokenValidation",
        hidden = true
    )]
    #[allow(clippy::unused_async)]
    /// Validate a RBAC token
    ///
    /// Make a not hard validation of the RBAC token, disabling
    async fn validate_rbac_token(
        &self,
        /// RBAC token provided for validation
        Json(_rbac_token): Json<CatalystRBACTokenV1>,
        /// No Authorization required, but Token permitted.
        _auth: InternalApiKeyAuthorization,
    ) -> registrations_get::AllResponses {
        registrations_get::AllResponses::unauthorized()
    }
}
