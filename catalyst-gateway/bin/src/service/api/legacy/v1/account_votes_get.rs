//! Implementation of the `GET /v1/votes/plan/account-votes/:account_id` endpoint

use std::sync::Arc;

use poem::web::Data;
use poem_extensions::{response, UniResponse::T200};
use poem_openapi::{param::Path, payload::Json};

use crate::{
    service::common::{
        objects::legacy::account_votes::{AccountId, AccountVote},
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
    200: OK<Json<Vec<AccountVote>>>,
    400: BadRequest<Json<Vec<AccountVote>>>,
    500: ServerError,
    503: ServiceUnavailable,
};

/// GET /v1/votes/plans/account-votes/:account_id
///
/// Get votes for an `account_id` endpoint.
///
/// For each active vote plan, this endpoint returns an array
/// with the proposal index number that the account voted for.
///
/// ## Responses
///
/// * 200 with a JSON array of the number of voted proposals in a plan.
/// * 400 Bad request with a JSON array of the number of voted proposals in a plan
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service has not started, do not send other requests.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    _state: Data<&Arc<State>>, _account_id: Path<AccountId>,
) -> AllResponses {
    // otherwise everything seems to be A-OK
    T200(OK(Json(Vec::new())))
}
