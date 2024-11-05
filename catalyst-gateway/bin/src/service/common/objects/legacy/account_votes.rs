//! Define the Account Votes.

use poem_openapi::{types::Example, NewType, Object};
use serde::Deserialize;

#[derive(NewType, Deserialize)]
#[oai(example = true)]
/// Unique ID of a user account.
pub(crate) struct AccountId(String);

impl Example for AccountId {
    fn example() -> Self {
        Self("0xa6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663".into())
    }
}

#[derive(NewType, Deserialize)]
#[oai(example = true)]
/// Unique ID of a vote plan.
pub(crate) struct VotePlanId(String);

impl Example for VotePlanId {
    fn example() -> Self {
        Self("0xa6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663".into())
    }
}

#[derive(NewType, Deserialize)]
#[oai(to_header = false, example = true)]
/// Array of the proposal numbers voted for by the account ID within the vote plan.
pub(crate) struct VotesVec(Vec<u8>);

impl Example for VotesVec {
    fn example() -> Self {
        Self(vec![1, 3, 9, 123])
    }
}

#[derive(Object, Deserialize)]
#[oai(example = true)]
/// Indexes of a proposal that the account has voted for across all active vote plans.
pub(crate) struct AccountVote {
    #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
    /// The hex-encoded ID of the vote plan.
    pub(crate) vote_plan_id: VotePlanId,
    /// Array of the proposal numbers voted for by the account ID within the vote plan.
    #[oai(validator(max_items = "500", minimum(value = "0"), maximum(value = "255")))]
    pub(crate) votes: VotesVec,
}

impl Example for AccountVote {
    fn example() -> Self {
        Self {
            vote_plan_id: VotePlanId::example(),
            votes: VotesVec(vec![1, 3, 9, 123]),
        }
    }
}

#[derive(NewType, Deserialize)]
#[oai(
    to_header = false,
    from_parameter = false,
    from_multipart = false,
    example = true
)]
/// Array of the proposal numbers voted for by the account ID within the vote plan.
pub(crate) struct AccountVotesVec(Vec<AccountVote>);

impl Example for AccountVotesVec {
    fn example() -> Self {
        Self(vec![AccountVote::example()])
    }
}
