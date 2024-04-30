//! Implementation of the GET /health/live endpoint

use poem_openapi::ApiResponse;

/// All responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// Service is Started and can serve requests.
    #[oai(status = 204)]
    NoContent,
}

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
    AllResponses::NoContent
}
