//! Define the Vote Plan

use poem_openapi::{types::Example, Enum, Object, Union};

/// Payload Type
#[derive(Enum)]
pub(crate) enum PayloadType {
    /// Private payload type
    Private,

    /// Public payload type
    Public,
}

/// Public Tally Result State Info
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct PublicTallyResultState {
    /// List of tally results
    results: Vec<u32>,

    /// Tally options
    options: TallyOptions,
}

impl Example for PublicTallyResultState {
    fn example() -> Self {
        Self {
            results: vec![0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
            options: TallyOptions::example(),
        }
    }
}

/// Public Tally Result Info
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct PublicTallyResult {
    /// Public tally result state
    result: PublicTallyResultState,
}

impl Example for PublicTallyResult {
    fn example() -> Self {
        Self {
            result: PublicTallyResultState::example(),
        }
    }
}

/// Encrypted Tally Result Info
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct EncryptedTally {
    /// Base64-encoded encrypted tally bytes
    encrypted_tally: String,
}

impl Example for EncryptedTally {
    fn example() -> Self {
        Self {
            encrypted_tally: "ZmFkc2Zhcw==".to_string(),
        }
    }
}

/// Decrypted Tally Result Info
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct DecryptedTally {
    /// Decrypted tally result state
    result: PublicTallyResultState,
}

impl Example for DecryptedTally {
    fn example() -> Self {
        Self {
            result: PublicTallyResultState::example(),
        }
    }
}

/// Private Tally Result State Info
#[derive(Union)]
pub(crate) enum PrivateTallyResultState {
    /// Encrypted tally result state
    Encrypted(EncryptedTally),
    /// Decrypted tally result state
    Decrypted(DecryptedTally),
}

impl Example for PrivateTallyResultState {
    fn example() -> Self {
        Self::Encrypted(EncryptedTally::example())
    }
}

/// Private Tally Result Info
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct PrivateTallyResult {
    /// Private tally result state
    state: PrivateTallyResultState,
}

impl Example for PrivateTallyResult {
    fn example() -> Self {
        Self {
            state: PrivateTallyResultState::example(),
        }
    }
}

/// Tally Result Info
#[derive(Union)]
pub(crate) enum TallyResults {
    /// Public tally result
    Public(PublicTallyResult),

    /// Private tally result
    Private(PrivateTallyResult),
}

impl Example for TallyResults {
    fn example() -> Self {
        Self::Public(PublicTallyResult::example())
    }
}

/// Tally Options
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct TallyOptions {
    /// Starting value of the vote option, starting from 0
    #[oai(validator(minimum(value = "0"), maximum(value = "15")))]
    start: u8,

    /// Upper bound of the available options, maximum being 16 (not included)
    #[oai(validator(minimum(value = "1"), maximum(value = "15")))]
    end: u8,
}

impl Example for TallyOptions {
    fn example() -> Self {
        Self { start: 0, end: 15 }
    }
}

/// Proposal Info
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct ProposalInfo {
    /// Index of the proposal status
    #[oai(validator(minimum(value = "0"), maximum(value = "255")))]
    id: u8,

    /// Hex-encoded proposal id
    #[oai(validator(max_length = 64, min_length = 64, pattern = "[0-9a-f]{64}"))]
    proposal_id: String,

    /// Tally options
    options: TallyOptions,

    /// Tally results
    tally: TallyResults,

    /// Amount of the vote cast transactions
    #[oai(validator(minimum(value = "0")))]
    votes_cast: u32,
}

impl Example for ProposalInfo {
    fn example() -> Self {
        Self {
            id: 0,
            proposal_id: "7db6f91f3c92c0aef7b3dd497e9ea275229d2ab4dba6a1b30ce6b32db9c9c3b2"
                .to_string(),
            options: TallyOptions::example(),
            tally: TallyResults::example(),
            votes_cast: 0,
        }
    }
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

    /// list of bench32-encoded member public keys
    committee_member_keys: Vec<String>,

    /// List of active proposals
    proposals: Vec<ProposalInfo>,

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
            committee_member_keys: Vec::new(),
            proposals: vec![ProposalInfo::example()],
            voting_token:
                "134c2d0a0b5761445d3f2d08492a5c193e3a19194453511426153630.0418401957301613"
                    .to_string(),
        }
    }
}
