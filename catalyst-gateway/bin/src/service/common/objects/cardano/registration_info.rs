//! Defines API schemas of [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration type.

use poem_openapi::{types::Example, Object, Union};

use crate::service::{
    api::cardano::types::{Nonce, PaymentAddress, PublicVotingInfo, TxId},
    common::objects::cardano::hash::Hash256,
    utilities::as_hex_string,
};

/// The Voting power and voting key of a Delegated voter.
#[derive(Object)]
struct Delegation {
    /// Voting key.
    #[oai(validator(min_length = "66", max_length = "66", pattern = "0x[0-9a-f]{64}"))]
    voting_key: String,

    /// Delegation power assigned to the voting key.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    power: i64,
}

/// Represents a list of delegations.
#[derive(Object)]
struct Delegations {
    /// A list of delegations.
    #[oai(validator(max_items = "100"))]
    delegations: Vec<Delegation>,
}

/// Voting `Key` for a direct voter (not delegated).
#[derive(Object)]
struct DirectVoter {
    /// Voting key.
    #[oai(validator(min_length = "66", max_length = "66", pattern = "0x[0-9a-f]{64}"))]
    voting_key: String,
}

/// The type of the Voting Key.
#[derive(Union)]
#[oai(discriminator_name = "type", one_of = true)]
enum VotingInfo {
    /// direct voting key
    Direct(DirectVoter),
    /// delegations
    Delegated(Delegations),
}

/// User's [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RegistrationInfo {
    /// Rewards address.
    #[oai(validator(min_length = "2", max_length = "116", pattern = "0x[0-9a-f]*"))]
    rewards_address: String,

    /// Transaction hash in which the [CIP-36](https://cips.cardano.org/cip/CIP-36/) registration is made.
    tx_hash: Hash256,

    /// Registration nonce.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    nonce: Nonce,

    /// Voting info.
    voting_info: VotingInfo,
}

impl RegistrationInfo {
    /// Creates a new `RegistrationInfo`
    #[allow(dead_code)]
    pub(crate) fn new(
        tx_hash: TxId, rewards_address: &PaymentAddress, voting_info: PublicVotingInfo,
        nonce: Nonce,
    ) -> Self {
        let voting_info = match voting_info {
            PublicVotingInfo::Direct(voting_key) => {
                VotingInfo::Direct(DirectVoter {
                    voting_key: as_hex_string(voting_key.bytes()),
                })
            },
            PublicVotingInfo::Delegated(delegations) => {
                VotingInfo::Delegated(Delegations {
                    delegations: delegations
                        .into_iter()
                        .map(|(voting_key, power)| {
                            Delegation {
                                voting_key: as_hex_string(voting_key.bytes()),
                                power,
                            }
                        })
                        .collect(),
                })
            },
        };
        Self {
            tx_hash: tx_hash.into(),
            rewards_address: as_hex_string(rewards_address),
            nonce,
            voting_info,
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
            voting_info: VotingInfo::Delegated(Delegations {
                delegations: vec![Delegation {
                    voting_key:
                        "0xb16f03d67e95ddd321df4bee8658901eb183d4cb5623624ff5edd7fe54f8e857"
                            .to_string(),
                    power: 1,
                }],
            }),
        }
    }
}
