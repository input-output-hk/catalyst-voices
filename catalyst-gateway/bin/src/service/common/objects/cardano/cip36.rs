//! CIP36 object

use poem_openapi::{types::Example, Object};

use crate::service::common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey;

/// List of CIP36 Registration Data as found on-chain.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct Cip36ReportingList {
    /// List of registrations associated with the same Voting Key
    #[oai(validator(max_items = "100000"))]
    cip36: Vec<Cip36Reporting>,
}

impl Cip36ReportingList {
    /// Create a new instance of `Cip36ReportingList`.
    pub(crate) fn new() -> Self {
        Self { cip36: vec![] }
    }

    /// Add a new `Cip36Reporting` to the list.
    pub(crate) fn add(&mut self, cip36: Cip36Reporting) {
        self.cip36.push(cip36);
    }
}

impl Example for Cip36ReportingList {
    fn example() -> Self {
        Self {
            cip36: vec![Cip36Reporting::example()],
        }
    }
}

/// CIP36 info + invalid reporting.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct Cip36Reporting {
    /// List of registrations.
    #[oai(validator(max_items = "100000"))]
    cip36: Vec<Cip36Info>,
    /// Invalid registration reporting.
    #[oai(validator(max_items = "100000"))]
    invalids: Vec<InvalidRegistrationsReport>,
}

impl Cip36Reporting {
    /// Create a new instance of `Cip36Reporting`.
    pub(crate) fn new(cip36: Vec<Cip36Info>, invalids: Vec<InvalidRegistrationsReport>) -> Self {
        Self { cip36, invalids }
    }
}

impl Example for Cip36Reporting {
    fn example() -> Self {
        Self {
            cip36: vec![Cip36Info::example()],
            invalids: vec![InvalidRegistrationsReport::example()],
        }
    }
}

/// CIP36 Registration Data as found on-chain.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct Cip36Info {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_pub_key: Ed25519HexEncodedPublicKey, // Validation provided by type
    /// Nonce value after normalization.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub nonce: u64,
    /// Slot Number the cert is in.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub slot_no: u64,
    /// Transaction Index.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub txn: i16,
    /// Voting Public Key
    #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
    pub vote_key: String,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    #[oai(validator(max_length = 116, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
    pub payment_address: String,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

impl Example for Cip36Info {
    fn example() -> Self {
        Self {
            stake_pub_key: Ed25519HexEncodedPublicKey::example(),
            nonce: 0,
            slot_no: 12345,
            txn: 0,
            vote_key: "0xa6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663"
                .to_string(),
            payment_address: "0x00588e8e1d18cba576a4d35758069fe94e53f638b6faf7c07b8abd2bc5c5cdee47b60edc7772855324c85033c638364214cbfc6627889f81c4".to_string(),
            is_payable: false,
            cip36: true,
        }
    }
}

/// Invalid registration error reporting.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct InvalidRegistrationsReport {
    /// Error report
    #[oai(validator(max_items = "100000", max_length = "100", pattern = ".*"))]
    pub error_report: Vec<String>,
    /// Full Stake Public Key (32 byte Ed25519 Public key, not hashed).
    pub stake_address: Ed25519HexEncodedPublicKey, // Validation provided by the type.
    /// Voting Public Key
    #[oai(validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]"))]
    pub vote_key: String,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    #[oai(validator(max_length = 116, min_length = 0, pattern = "[0-9a-f]"))]
    pub payment_address: String,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

impl Example for InvalidRegistrationsReport {
    fn example() -> Self {
        Self {
            error_report: vec!["Invalid registration".to_string()],
            stake_address: Ed25519HexEncodedPublicKey::example(),
            vote_key: "0xa6a3c0447aeb9cc54cf6422ba32b294e5e1c3ef6d782f2acff4a70694c4d1663".to_string(),
            payment_address: "0x00588e8e1d18cba576a4d35758069fe94e53f638b6faf7c07b8abd2bc5c5cdee47b60edc7772855324c85033c638364214cbfc6627889f81c4".to_string(),
            is_payable: false,
            cip36: true,
        }
    }
}
