//! Implementation of the GET /health/live endpoint

use poem_extensions::{response, UniResponse::T204};
use tracing::{error, info, warn};

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

/// # GET /health/live
///
/// Liveness endpoint.
///
/// Kubernetes (and others) use this endpoint to determine if the service is able
/// to keep running.
///
/// In this service, liveness is assumed unless there are multiple panics generated
/// by an endpoint in a short window.
///
/// ## Responses
///
/// * 204 No Content - Service is OK and can keep running.
/// * 400 API Validation Error
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service is possibly not running reliably.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    // TODO: Detect if too many panics have occurred in a defined window.
    // If so, return a 503
    // T503(ServiceUnavailable)

    info!("liveness check");
    warn!("liveness check - warn");
    error!("liveness check - error");

    // otherwise everything seems to be A-OK
    T204(NoContent)
}
