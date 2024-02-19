//! Implementation of the GET /fragments endpoint

use poem_extensions::{response, UniResponse::T200};
use poem_openapi::payload::Json;

use crate::service::common::{
    objects::legacy::{
        fragments_batch::FragmentsBatch, fragments_processing_summary::FragmentsProcessingSummary,
    },
    responses::{
        resp_2xx::OK,
        resp_4xx::BadRequest,
        resp_5xx::{ServerError, ServiceUnavailable},
    },
};

/// All responses
pub(crate) type AllResponses = response! {
    200: OK<Json<FragmentsProcessingSummary>>,
    400: BadRequest<Json<FragmentsProcessingSummary>>,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET /fragments
///
/// Process a fragments batch.
///
/// ## Responses
///
/// * 200 No Content - Service is OK and can keep running.
/// * 400 Bad Request
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service is possibly not running reliably.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_fragments_batch: FragmentsBatch) -> AllResponses {
    T200(OK(Json(FragmentsProcessingSummary::default())))
}
