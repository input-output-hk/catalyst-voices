//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

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
pub(crate) async fn endpoint(_message: Vec<dto::VotingHistoryItem>) -> AllResponses {
    Responses::Ok(Json(Vec::new())).into()
}

/// The data transfer objects over HTTP
pub(crate) mod dto {
    use poem_openapi::Object;

    /// An option item to specify proposal to query.
    #[allow(clippy::missing_docs_in_private_items)]
    #[derive(Object, Default)]
    pub(crate) struct VotingHistoryItem {
        #[oai(validator(max_length = 256, min_length = 0, pattern = "[A-Za-z0-9_-]"))]
        vote_plan_id: String,
        #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
        indexes: u32,
    }
}
