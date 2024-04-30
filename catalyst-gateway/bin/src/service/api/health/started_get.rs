//! Implementation of the GET /health/started endpoint

use poem_openapi::ApiResponse;

/// All responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// Service is Started and can serve requests.
    #[oai(status = 204)]
    NoContent,
}

/// # GET /health/started
///
/// Service Started endpoint.
///
/// Kubernetes (and others) use this endpoint to determine if the service has started
/// properly and is able to serve requests.
///
/// In this service, started is guaranteed if this endpoint is reachable.
/// So, it will always just return 204.
///
/// In theory it can also return 503 is the service has some startup processing
/// to complete before it is ready to serve requests.
///
/// An example of not being started could be that bulk data needs to be read
/// into memory or processed in some way before the API can return valid
/// responses.  In that scenario this endpoint would return 503 until that
/// startup processing was fully completed.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    AllResponses::NoContent
}
