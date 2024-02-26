//! Implementation of the POST /message endpoint

use poem_extensions::{response, UniResponse::T200};
use poem_openapi::payload::{Binary, Json};

use crate::service::common::{
    objects::legacy::fragments_processing_summary::FragmentsProcessingSummary,
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

/// # POST /message
///
/// Message post endpoint.
///
/// When successful, returns a summary of fragments accepted and rejected.
///
/// ## Responses
///
/// * 200 JSON Fragments Processing Summary - Contains information about accepted and
///   rejected fragments.
/// * 400 JSON Fragments Processing Summary - Contains information about accepted and
///   rejected fragments.
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service has not started, do not send other requests.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_message: Binary<Vec<u8>>) -> AllResponses {
    // otherwise everything seems to be A-OK
    T200(OK(Json(FragmentsProcessingSummary::default())))
}
