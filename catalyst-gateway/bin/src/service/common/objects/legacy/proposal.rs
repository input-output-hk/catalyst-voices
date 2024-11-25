//! Define the Proposal

use std::collections::HashMap;

use poem_openapi::Object;

/// The proposal object.
#[allow(clippy::missing_docs_in_private_items)]
#[allow(clippy::struct_field_names)]
#[derive(Object, Default)]
pub(crate) struct Proposal {
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    internal_id: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    chain_voteplan_id: String,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    chain_proposal_index: u32,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    chain_vote_encryption_key: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    chain_voteplan_payload: String,
    #[oai(validator(
        max_length = 32767,
        min_length = 0,
        pattern = "[\\s\\S]",
        max_properties = 100,
        min_properties = 0
    ))]
    chain_vote_options: HashMap<String, String>,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    proposal_public_key: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    fund_id: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    proposal_summary: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    proposal_importance: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    proposal_title: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    proposal_goal: String,
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    proposal_url: String,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    proposal_funds: u32,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    reviews_count: u32,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    proposal_impact_score: u32,
    #[oai]
    proposer: Option<Proposer>,
}

/// The proposer object.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct Proposer {
    #[oai(validator(max_length = 32767, min_length = 0, pattern = "[\\s\\S]"))]
    proposer_name: String,
}
