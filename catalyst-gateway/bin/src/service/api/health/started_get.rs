//! Implementation of the GET /health/started endpoint

use poem_extensions::{response, UniResponse::T204};

use crate::service::common::responses::{
    resp_2xx::NoContent,
    resp_4xx::ApiValidationError,
    resp_5xx::{ServerError, ServiceUnavailable},
};

/// All responses
pub(crate) type AllResponses = response! {
    204: NoContent,
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

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
///
/// ## Responses
///
/// * 204 No Content - Service is Started and can  serve requests.
/// * 400 API Validation Error
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service has not started, do not send other requests.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    // otherwise everything seems to be A-OK
    T204(NoContent)
}
