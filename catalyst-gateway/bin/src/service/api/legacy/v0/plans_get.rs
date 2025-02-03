//! Implementation of the GET /vote/active/plans endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{objects::legacy::vote_plan::VotePlan, responses::WithErrorResponses};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## Ok
    /// 
    /// JSON array with the list of vote plans with their respective data.
    #[oai(status = 200)]
    Ok(Json<Vec<VotePlan>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// GET /v0/vote/active/plans
///
/// Get all active vote plans endpoint.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    Responses::Ok(Json(Vec::new())).into()
}
