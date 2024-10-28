//! Define the Vote Plan

use poem_openapi::{types::Example, Object};

/// Voting Plan Information.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct VotePlan {
    /// Voting token identifier
    #[oai(validator(
        max_length = 121,
        min_length = 59,
        pattern = r"[0-9a-f]{56}\.[0-9a-f]{2,64}"
    ))]
    voting_token: String,
}

impl Example for VotePlan {
    fn example() -> Self {
        Self {
            voting_token:
                "134c2d0a0b5761445d3f2d08492a5c193e3a19194453511426153630.0418401957301613"
                    .to_string(),
        }
    }
}
