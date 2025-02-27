//! Implementation of the GET `/rbac/registrations` endpoint.

use poem_openapi::{payload::Json, ApiResponse};
use tracing::error;

use super::{
    rbac_registration::RbacRegistrations, unprocessable_content::RbacUnprocessableContent,
};
use crate::{
    db::index::session::CassandraSession,
    service::common::{
        responses::WithErrorResponses,
        types::{
            cardano::query::stake_or_voter::StakeOrVoter, headers::retry_after::RetryAfterOption,
        },
    },
};

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// ## Ok
    ///
    /// Success returns a list of registration transaction ids.
    #[oai(status = 200)]
    Ok(Json<RbacRegistrations>),

    /// No valid registration.
    #[oai(status = 404)]
    NotFound,

    /// Response for unprocessable content.
    #[oai(status = 422)]
    UnprocessableContent(Json<RbacUnprocessableContent>),
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get RBAC registration endpoint.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_lookup: Option<StakeOrVoter>) -> AllResponses {
    let Some(_session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow::anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    Responses::NotFound.into()
}
