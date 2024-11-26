//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use super::VoteHistoryItem;
use crate::service::common::{objects::legacy::proposal::Proposal, responses::WithErrorResponses};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success response.
    #[oai(status = 200)]
    Ok(Json<Vec<Proposal>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_message: Vec<VoteHistoryItem>) -> AllResponses {
    Responses::Ok(Json(Vec::new())).into()
}
