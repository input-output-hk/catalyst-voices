//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success response.
    #[oai(status = 200)]
    Ok(Json<Vec<dto::Proposal>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    Responses::Ok(Json(Vec::new())).into()
}

/// The data transfer objects over HTTP
pub(crate) mod dto {
    use std::collections::HashMap;

    use poem_openapi::Object;

    #[allow(clippy::missing_docs_in_private_items)]
    #[allow(clippy::struct_field_names)]
    #[derive(Object, Default)]
    pub(crate) struct Proposal {
        internal_id: String,
        chain_voteplan_id: String,
        chain_proposal_index: u32,
        chain_vote_encryption_key: String,
        chain_voteplan_payload: String,
        chain_vote_options: HashMap<String, String>,
        proposal_public_key: String,
        fund_id: String,
        proposal_summary: String,
        proposal_importance: String,
        proposal_title: String,
        proposal_goal: String,
        proposal_url: String,
        proposal_funds: u32,
        reviews_count: u32,
        proposal_impact_score: u32,
        proposer: Option<Proposer>,
    }

    #[allow(clippy::missing_docs_in_private_items)]
    #[derive(Object, Default)]
    pub(crate) struct Proposer {
        proposer_name: String,
    }
}
