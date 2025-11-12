//! RBAC endpoints.

use poem_openapi::{OpenApi, param::Query};

use crate::service::common::{
    auth::none_or_rbac::NoneOrRBAC,
    tags::ApiTags,
    types::{cardano::query::cat_id_or_stake::CatIdOrStake, generic::boolean::BooleanFlag},
};

mod registrations_get;

/// Cardano RBAC API Endpoints.
pub(crate) struct Api;

#[OpenApi(tag = "ApiTags::Cardano")]
impl Api {
    #[oai(
        path = "/v1/rbac/registration",
        method = "get",
        operation_id = "rbacRegistrations"
    )]
    /// Get RBAC registrations.
    ///
    /// This endpoint returns RBAC registrations by provided auth Catalyst Id credentials
    /// or by the `lookup` argument if provided.
    async fn rbac_registrations_get_v1(
        &self,
        /// Stake address or Catalyst ID to get the RBAC registration for.
        Query(lookup): Query<Option<CatIdOrStake>>,
        /// No Authorization required, but Token permitted.
        auth: NoneOrRBAC,
    ) -> registrations_get::AllResponsesV1 {
        let token = auth.into();
        // `Box::pin` is used here because of the future size (`clippy::large_futures` lint).
        Box::pin(registrations_get::endpoint_v1(lookup, token)).await
    }

    #[oai(
        path = "/v2/rbac/registration",
        method = "get",
        operation_id = "rbacRegistrationsV2"
    )]
    /// Get RBAC registrations V2.
    ///
    /// This endpoint returns RBAC registrations by provided auth Catalyst Id credentials
    /// or by the `lookup` argument if provided.
    async fn rbac_registrations_get_v2(
        &self,
        /// Stake address or Catalyst ID to get the RBAC registration for.
        Query(lookup): Query<Option<CatIdOrStake>>,
        /// No Authorization required, but Token permitted.
        auth: NoneOrRBAC,
        /// If this parameter is set to `true`, then all the invalid registrations are
        /// returned. Otherwise, only the invalid registrations after the last valid one
        /// are shown.  Defaults to `false` if not present.
        Query(show_all_invalid): Query<Option<BooleanFlag>>,
    ) -> registrations_get::AllResponsesV2 {
        let token = auth.into();
        // `Box::pin` is used here because of the future size (`clippy::large_futures` lint).
        Box::pin(registrations_get::endpoint_v2(
            lookup,
            token,
            show_all_invalid.is_some_and(Into::into),
        ))
        .await
    }
}
