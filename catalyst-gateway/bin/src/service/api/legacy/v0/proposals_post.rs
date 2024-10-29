//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use super::proposals_get;
use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success resposne.
    #[oai(status = 200)]
    Ok(Json<Vec<proposals_get::dto::Proposal>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_message: Vec<dto::VotingHistoryItem>) -> AllResponses {
    Responses::Ok(Json(Vec::new())).into()
}

/// The data transfer objects over HTTP
pub(crate) mod dto {
    use poem_openapi::Object;

    #[allow(clippy::missing_docs_in_private_items)]
    #[derive(Object, Default)]
    pub(crate) struct VotingHistoryItem {
        vote_plan_id: String,
        indexes: u32,
    }
}
