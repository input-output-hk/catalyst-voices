//! Define the Account Votes.

use poem_openapi::{types::Example, NewType, Object};
use serde::Deserialize;

#[derive(NewType, Deserialize)]
#[oai(example = true)]
/// Unique ID of a user account.
pub(crate) struct AccountId(
    // TODO - recheck max length, min length, and pattern
    #[oai(validator(max_length = 64, min_length = 64, pattern = "[0-9a-f]{64}"))] String,
);

impl Example for AccountId {
    fn example() -> Self {
        Self("a6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663".into())
    }
}

#[derive(NewType, Deserialize)]
#[oai(example = true)]
/// Unique ID of a vote plan.
pub(crate) struct VotePlanId(String);

impl Example for VotePlanId {
    fn example() -> Self {
        Self("a6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663".into())
    }
}

#[derive(Object, Deserialize)]
#[oai(example = true)]
/// Indexes of a proposal that the account has voted for across all active vote plans.
pub(crate) struct AccountVote {
    #[oai(validator(max_length = 64, min_length = 64, pattern = "[0-9a-f]{64}"))]
    /// The hex-encoded ID of the vote plan.
    pub(crate) vote_plan_id: VotePlanId,
    /// Array of the proposal numbers voted for by the account ID within the vote plan.
    // TODO - Recheck max items and max value
    #[oai(validator(max_items = "100", minimum(value = "0"), maximum(value = "500")))]
    pub(crate) votes: Vec<u8>,
}

impl Example for AccountVote {
    fn example() -> Self {
        Self {
            vote_plan_id: VotePlanId::example(),
            votes: vec![1, 3, 9, 123],
        }
    }
}
