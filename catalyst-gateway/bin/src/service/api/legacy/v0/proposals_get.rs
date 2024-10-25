//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    #[oai(status = 200)]
    Ok(Json<Vec<dto::Proposal>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    Responses::Ok(Json(Vec::new())).into()
}

pub(crate) mod dto {
    use std::collections::HashMap;

    use poem_openapi::Object;

    #[derive(Object, Default)]
    pub(crate) struct Proposal {
        internal_id: String,
        chain_voteplan_id: String,
        chain_proposal_index: u32,
        chain_vote_encryption_key: String,
        chain_voteplan_payload: String,
        chain_vote_options: HashMap<String, String>,
        proposal_public_key: String,
    }
}
