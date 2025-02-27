//! RBAC endpoints.

use poem::http::HeaderMap;
use poem_openapi::{param::Query, payload::Json, OpenApi};

use crate::service::common::{
    auth::none_or_rbac::NoneOrRBAC, tags::ApiTags,
    types::cardano::query::stake_or_voter::StakeOrVoter,
};

mod registrations_get;
mod unprocessable_content;
mod rbac_registration;

/// Cardano RBAC API Endpoints
pub(crate) struct Api;

#[OpenApi(tag = "ApiTags::Cardano")]
impl Api {
    #[oai(
        path = "/draft/rbac/registrations/:catalyst_id",
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
        /// Headers, used if the query is requesting ALL to determine if the secret API
        /// Key is also defined.
        headers: &HeaderMap,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> registrations_get::AllResponses {
        // Special validation for the `lookup` parameter.
        // If the parameter is ALL, BUT we do not have a valid API Key, just report the parameter
        // is invalid.
        if let Some(lookup) = lookup.clone() {
            if lookup.is_all(headers).is_err() {
                return registrations_get::Responses::UnprocessableContent(Json(
                    unprocessable_content::RbacUnprocessableContent::new("Invalid Stake Address or Voter key"),
                ))
                .into();
            }
        }

        registrations_get::endpoint(lookup).await
    }
}
