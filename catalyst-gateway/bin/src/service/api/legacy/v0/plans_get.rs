//! Implementation of the GET /vote/active/plans endpoint

use std::sync::Arc;

use poem::web::Data;
use poem_openapi::{payload::Json, ApiResponse};

use crate::{service::common::objects::legacy::vote_plan::VotePlan, state::State};

/// All responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// JSON array with the list of vote plans with their respective data.
    #[oai(status = 200)]
    Ok(Json<Vec<VotePlan>>),
}

/// GET /v0/vote/active/plans
///
/// Get all active vote plans endpoint.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_state: Data<&Arc<State>>) -> AllResponses {
    AllResponses::Ok(Json(Vec::new()))
}
