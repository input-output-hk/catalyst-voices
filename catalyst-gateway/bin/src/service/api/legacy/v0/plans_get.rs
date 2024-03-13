//! Implementation of the GET /vote/active/plans endpoint

use std::sync::Arc;

use poem::web::Data;
use poem_extensions::{response, UniResponse::T200};
use poem_openapi::payload::Json;

use crate::{
    service::common::{
        objects::legacy::vote_plan::VotePlan,
        responses::{
            resp_2xx::OK,
            resp_4xx::BadRequest,
            resp_5xx::{ServerError, ServiceUnavailable},
        },
    },
    state::State,
};

/// All responses
pub(crate) type AllResponses = response! {
    200: OK<Json<Vec<VotePlan>>>,
    400: BadRequest<Json<Vec<VotePlan>>>,
    500: ServerError,
    503: ServiceUnavailable,
};

/// GET /v0/vote/active/plans
///
/// Get all active vote plans endpoint.
///
/// ## Responses
///
/// * 200 with a JSON array with the list of vote plans with their respective data.
/// * 400 Bad request with a JSON array with the list of vote plans with their respective
///   data.
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service has not started, do not send other requests.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_state: Data<&Arc<State>>) -> AllResponses {
    // otherwise everything seems to be A-OK
    T200(OK(Json(Vec::new())))
}
