//! Defines API schemas of [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration type.

use poem_openapi::{types::Example, Object};

/// User's [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RegistrationInfo {
    /// Rewards address.
    #[oai(validator(min_length = "2", max_length = "116", pattern = "0x[0-9a-f]*"))]
    pub(crate) rewards_address: String,

    /// Transaction id in which the [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration is made.
    #[oai(validator(min_length = "66", max_length = "66", pattern = "0x[0-9a-f]{64}"))]
    pub(crate) tx_id: String,
}

impl Example for RegistrationInfo {
    fn example() -> Self {
        Self {
            rewards_address: "0x0004047d932c83d551083c08959f293ff69c7ed2218f6923ec102cfffdfea0a5ba6e9bf493c239df735d1dcf909fdd4b41067246aecf1e4500".to_string(),
            tx_id: "0x0000000000000000000000000000000000000000000000000000000000000000".to_string(),
        }
    }
}
