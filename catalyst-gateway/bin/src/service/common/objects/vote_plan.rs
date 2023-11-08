//! Define the Vote Plan

use poem_openapi::{types::Example, Enum, Object};

/// Payload Type
#[derive(Enum)]
pub(crate) enum PayloadType {
    /// Private payload type
    Private,

    /// Public payload type
    Public,
}

/// Vote Plan
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct VotePlan {
    /// Hex-encoded vote plan ID
    #[oai(validator(max_length = 64, min_length = 64, pattern = "[0-9a-f]{64}"))]
    id: String,

    /// Type of payload to expect
    payload_type: PayloadType,

    /// Epoch and slot ID of vote start time
    #[oai(validator(min_length = 3, pattern = "[0-9]+\\.[0-9]+"))]
    vote_start: String,

    /// Epoch and slot ID of vote end time
    #[oai(validator(min_length = 3, pattern = "[0-9]+\\.[0-9]+"))]
    vote_end: String,

    /// Epoch and slot ID of committee end time
    #[oai(validator(min_length = 3, pattern = "[0-9]+\\.[0-9]+"))]
    committee_end: String,

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
            id: "7db6f91f3c92c0aef7b3dd497e9ea275229d2ab4dba6a1b30ce6b32db9c9c3b2".to_string(),
            payload_type: PayloadType::Public,
            vote_start: "0.0".to_string(),
            vote_end: "0.0".to_string(),
            committee_end: "0.0".to_string(),
            voting_token:
                "134c2d0a0b5761445d3f2d08492a5c193e3a19194453511426153630.0418401957301613"
                    .to_string(),
        }
    }
}
