//! Implementation of the GET /fragments/statuses endpoint

use std::collections::HashMap;

use poem_extensions::{response, UniResponse::T200};
use poem_openapi::payload::Json;

use crate::service::common::{
    objects::fragment_status::FragmentStatus,
    responses::{
        resp_2xx::OK,
        resp_5xx::{ServerError, ServiceUnavailable},
    },
};

/// Comma-separated (no spaces in between) list of fragment IDs.
#[derive(poem_openapi::NewType)]
pub(crate) struct FragmentIds(String);

/// All responses
pub(crate) type AllResponses = response! {
    200: OK<Json<HashMap<String, FragmentStatus>>>,
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
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service is possibly not running reliably.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_fragment_ids: FragmentIds) -> AllResponses {
    T200(OK(Json(HashMap::new())))
}
