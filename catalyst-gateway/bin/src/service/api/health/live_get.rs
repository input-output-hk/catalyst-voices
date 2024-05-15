//! Implementation of the GET /health/live endpoint

use std::sync::atomic::{AtomicBool, Ordering};

use poem_openapi::ApiResponse;

use crate::service::common::responses::WithErrorResponses;

/// Flag to determine if the service has started
static IS_LIVE: AtomicBool = AtomicBool::new(true);

/// Set the started flag to `true`
#[allow(dead_code)]
pub(crate) fn set_live(flag: bool) {
    IS_LIVE.store(flag, Ordering::Relaxed);
}
/// Get the started flag
#[allow(dead_code)]
fn is_live() -> bool {
    IS_LIVE.load(Ordering::Relaxed)
}

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Service is OK and can keep running.
    #[oai(status = 204)]
    NoContent,
    /// Service is possibly not running reliably.
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
    if true {
        Responses::NoContent.into()
    } else {
        Responses::ServiceUnavailable.into()
    }
}
