//! Implementation of the `GET /health/live` endpoint.

use poem_openapi::ApiResponse;

use crate::service::{common::responses::WithErrorResponses, utilities::health::is_live};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## No Content
    ///
    /// Service is OK and can keep running.
    #[oai(status = 204)]
    NoContent,
    /// Service is not running.
    #[oai(status = 503)]
    ServiceUnavailable,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET /health/live
///
/// Liveness endpoint.
///
/// Kubernetes (and others) use this endpoint to determine if the service is able
/// to keep running.
///
/// In this service, liveness is assumed unless there are multiple panics generated
/// by an endpoint in a short window.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    // TODO: Needs engineering discussion
    if is_live() {
        Responses::NoContent.into()
    } else {
        Responses::ServiceUnavailable.into()
    }
}
