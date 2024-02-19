//! Implementation of the GET /fragments/statuses endpoint

use std::collections::HashMap;

use poem_extensions::{response, UniResponse::T200};
use poem_openapi::payload::Json;

use crate::service::common::{
    objects::legacy::{fragment_status::FragmentStatus, fragments_processing_summary::FragmentId},
    responses::{
        resp_2xx::OK,
        resp_4xx::BadRequest,
        resp_5xx::{ServerError, ServiceUnavailable},
    },
};

/// All responses
pub(crate) type AllResponses = response! {
    200: OK<Json<HashMap<String, FragmentStatus>>>,
    400: BadRequest<Json<HashMap<String, FragmentStatus>>>,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET /fragments/statuses
///
/// Get fragments statuses endpoint.
///
/// ## Responses
///
/// * 200 Fragments Statuses - Statuses of the fragments by id.
/// * 400 Bad Request
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service is possibly not running reliably.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_fragment_ids: Vec<FragmentId>) -> AllResponses {
    T200(OK(Json(HashMap::new())))
}
