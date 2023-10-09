use chrono::{DateTime, Utc};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Voteplan {
    pub id: i32,
    pub chain_voteplan_id: String,
    pub chain_vote_start_time: DateTime<Utc>,
    pub chain_vote_end_time: DateTime<Utc>,
    pub chain_committee_end_time: DateTime<Utc>,
    pub chain_voteplan_payload: String,
    pub chain_vote_encryption_key: String,
    pub fund_id: i32,
    pub token_identifier: String,
}
