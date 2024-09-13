use chrono::{DateTime, Utc};

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Voteplan {
    pub(crate) id: i32,
    pub(crate) chain_voteplan_id: String,
    pub(crate) chain_vote_start_time: DateTime<Utc>,
    pub(crate) chain_vote_end_time: DateTime<Utc>,
    pub(crate) chain_committee_end_time: DateTime<Utc>,
    pub(crate) chain_voteplan_payload: String,
    pub(crate) chain_vote_encryption_key: String,
    pub(crate) fund_id: i32,
    pub(crate) token_identifier: String,
}
