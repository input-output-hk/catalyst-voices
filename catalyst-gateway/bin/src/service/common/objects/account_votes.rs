//! Define the Account Votes.

use poem_openapi::{types::Example, Object};
use serde::Deserialize;

#[derive(Object, Deserialize)]
#[oai(example = true)]
/// Indexes of proposal that a given user has voted for across all active vote plans.
pub(crate) struct AccountVote {
    /// The hex-encoded ID of the vote plan.
    vote_plan_id: String,
    /// Array of numbers of proposals voted for by the account ID within the vote plan.
    votes: Vec<u8>,
}

impl Example for AccountVote {
    fn example() -> Self {
        Self {
            vote_plan_id: "a6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663".into(),
            votes: vec![1, 3, 9, 123],
        }
    }
}
