//! Defines API schemas of [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration type.

use poem_openapi::{types::Example, Object, Union};

use crate::{
    event_db::voter_registration::{Nonce, PaymentAddress, TxId},
    service::common::objects::cardano::hash::Hash,
};

/// Delegation type
#[derive(Object)]
struct Delegation {
    /// Voting key.
    #[oai(validator(min_length = "66", max_length = "66", pattern = "0x[0-9a-f]{64}"))]
    voting_key: String,

    /// Delegation power assigned to the voting key.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    power: i64,
}

/// Voting key type
#[derive(Union)]
enum VotingInfo {
    /// direct voting key
    Direct(String),
    /// delegations
    Delegated(Vec<Delegation>),
}

/// User's [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RegistrationInfo {
    /// Rewards address.
    #[oai(validator(min_length = "2", max_length = "116", pattern = "0x[0-9a-f]*"))]
    rewards_address: String,

    /// Transaction hash in which the [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration is made.
    tx_hash: Hash,

    /// Registration nonce.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    nonce: Nonce,

    /// Voting info.
    voting_info: VotingInfo,
}

impl RegistrationInfo {
    /// Creates a new `RegistrationInfo`
    pub(crate) fn new(tx_hash: TxId, rewards_address: PaymentAddress, nonce: Nonce) -> Self {
        Self {
            tx_hash: tx_hash.into(),
            rewards_address: format!("0x{}", hex::encode(rewards_address)),
            nonce,
            voting_info: VotingInfo::Delegated(vec![]),
        }
    }
}

impl Example for RegistrationInfo {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self {
            rewards_address: "0xe0f9722f71d23654387ec1389fe253d380653f4f7e7305a80cf5c4dfa1"
                .to_string(),
            tx_hash: hex::decode(
                "27551498616e8da138780350a7cb8c18ef72cb01b0a6d40c785d095bcc8b1973",
            )
            .expect("Invalid hex")
            .into(),
            nonce: 11_623_850,
            voting_info: VotingInfo::Delegated(vec![]),
        }
    }
}
