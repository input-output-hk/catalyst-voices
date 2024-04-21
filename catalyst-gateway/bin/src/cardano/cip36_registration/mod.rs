//! Verify registration TXs

use std::io::Cursor;

use cardano_chain_follower::Network;
use ciborium::Value;
use cryptoxide::{blake2b::Blake2b, digest::Digest};
use pallas::ledger::{primitives::Fragment, traverse::MultiEraMeta};
use serde::{Deserialize, Serialize};

/// Networks
const NETWORK_ID: usize = 0;

/// Cip36 - 61284 entries
const KEY_61284: usize = 0;

/// Cip36
const STAKE_ADDRESS: usize = 1;
/// Cip36
const PAYMENT_ADDRESS: usize = 2;
/// Cip36
const NONCE: usize = 3;
/// Cip36
const VOTE_PURPOSE: usize = 4;
/// Cip36
const DELEGATIONS_OR_DIRECT: usize = 0;
/// Cip36
const VOTE_KEY: usize = 0;
/// Cip36
const WEIGHT: usize = 1;

/// <https://cips.cardano.org/cips/cip36>
const CIP36_61284: u64 = 61284;
/// <https://cips.cardano.org/cips/cip36>
const CIP36_61285: u64 = 61285;

/// Pub key
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub(crate) struct PubKey(Vec<u8>);

/// Nonce
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub(crate) struct Nonce(pub i64);

/// Voting purpose
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub(crate) struct VotingPurpose(u64);

/// Rewards address
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub(crate) struct RewardsAddress(pub Vec<u8>);

/// Error report for serializing
pub(crate) type ErrorReport = Vec<String>;

/// Size of a single component of an Ed25519 signature.
const COMPONENT_SIZE: usize = 32;

/// Size of an `R` or `s` component of an Ed25519 signature when serialized
/// as bytes.
type ComponentBytes = [u8; COMPONENT_SIZE];

/// Ed25519 signature serialized as a byte array.
type SignatureBytes = [u8; Signature::BYTE_SIZE];

impl PubKey {
    /// Get credentials, a blake2b 28 bytes hash of the pub key
    pub(crate) fn get_credentials(&self) -> [u8; 28] {
        let mut digest = [0u8; 28];
        let mut context = Blake2b::new(28);
        context.input(&self.0);
        context.result(&mut digest);
        digest
    }

    /// Get bytes
    pub(crate) fn bytes(&self) -> &[u8] {
        &self.0
    }
}

/// Ed25519 signature.
///
/// This type represents a container for the byte serialization of an Ed25519
/// signature, and does not necessarily represent well-formed field or curve
/// elements.
///
/// Signature verification libraries are expected to reject invalid field
/// elements at the time a signature is verified.
#[derive(Copy, Clone, Eq, PartialEq, Debug)]
#[repr(C)]
pub struct Signature {
    /// Component of an Ed25519 signature when serialized as bytes
    r: ComponentBytes,
    /// Component of an Ed25519 signature when serialized as bytes
    s: ComponentBytes,
}

impl Signature {
    /// Size of an encoded Ed25519 signature in bytes.
    pub const BYTE_SIZE: usize = COMPONENT_SIZE * 2;

    /// Parse an Ed25519 signature from a byte slice.
    pub fn from_bytes(bytes: &SignatureBytes) -> Self {
        let mut r = ComponentBytes::default();
        let mut s = ComponentBytes::default();

        let components = bytes.split_at(COMPONENT_SIZE);
        r.copy_from_slice(components.0);
        s.copy_from_slice(components.1);

        Self { r, s }
    }
}

/// Cddl schema:
/// <https://cips.cardano.org/cips/cip36/schema.cddl>
pub struct CddlConfig {
    /// Cip36 cddl representation
    cip_36: String,
}

impl CddlConfig {
    #[must_use]
    /// Create cddl config
    pub fn new() -> Self {
        let cip_36: String = include_str!("cip36.cddl").to_string();

        CddlConfig { cip_36 }
    }
}

/// The source of voting power for a given registration
///
/// The voting power can either come from:
///  - a single wallet, OR
///  - a set of delegations
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum VotingInfo {
    /// Direct voting
    ///
    /// Voting power is based on the staked ada of the given key
    Direct(PubKey),

    /// Delegated voting
    ///
    /// Voting power is based on the staked ada of the delegated keys
    /// order of elements is important and must be preserved.
    Delegated(Vec<(PubKey, i64)>),
}

/// A catalyst CIP-36 registration on Cardano
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct Cip36Registration {
    /// Voting key
    pub voting_key: Option<VotingInfo>,
    /// Stake key
    pub stake_key: Option<PubKey>,
    /// Rewards address
    pub rewards_address: Option<RewardsAddress>,
    /// Nonce
    pub nonce: Option<Nonce>,
    /// Optional voting purpose
    pub voting_purpose: Option<VotingPurpose>,
    /// Raw cbor
    pub raw_cbor_cip36: Option<Vec<u8>>,
    /// Witness signature 61285
    pub signature: Option<Signature>,
    /// Errors report
    pub errors_report: ErrorReport,
}

impl Cip36Registration {
    /// Create new `Cip36Registration` from tx metadata
    /// Collect secondary errors for granular json error report
    #[allow(clippy::too_many_lines)]
    pub(crate) fn generate_from_tx_metadata(
        tx_metadata: &MultiEraMeta, network: Network,
    ) -> anyhow::Result<Option<Self>> {
        if tx_metadata.is_empty() {
            return Ok(None);
        }

        let mut voting_key: Option<VotingInfo> = None;
        let mut stake_key: Option<PubKey> = None;
        let mut voting_purpose: Option<VotingPurpose> = None;
        let mut rewards_address: Option<RewardsAddress> = None;
        let mut nonce: Option<Nonce> = None;
        let mut raw_cbor_cip36: Option<Vec<u8>> = None;
        let mut signature: Option<Signature> = None;
        let mut errors_report = Vec::new();

        if let pallas::ledger::traverse::MultiEraMeta::AlonzoCompatible(tx_metadata) = tx_metadata {
            for (key, cip36_registration) in tx_metadata.iter() {
                match *key {
                    CIP36_61284 => {
                        raw_cbor_cip36 = tx_metadata.encode_fragment().map_or_else(
                            |err| {
                                errors_report.push(format!("61284 invalid cbor {err}"));
                                None
                            },
                            Some,
                        );

                        let Some(raw_cbor) = raw_cbor_cip36.as_ref() else {
                            continue;
                        };

                        let decoded: ciborium::value::Value =
                            ciborium::de::from_reader(Cursor::new(raw_cbor))?;

                        let meta_61284 = if let Value::Map(m) = decoded {
                            m.iter().map(|entry| entry.1.clone()).collect::<Vec<_>>()
                        } else {
                            errors_report.push(format!("61284 parent cddl invalid {decoded:?}"));
                            continue;
                        };

                        // 4 entries inside metadata map with one optional entry for the voting
                        // purpose
                        let metamap = match inspect_metamap_reg(&meta_61284) {
                            Ok(value) => value,
                            Err(err) => {
                                errors_report.push(format!(
                                    "61284 child cddl invalid {} {err}",
                                    hex::encode(raw_cbor)
                                ));
                                continue;
                            },
                        };

                        // voting key: simply an ED25519 public key. This is the spending credential
                        // in the side chain that will receive voting power
                        // from this delegation. For direct voting it's
                        // necessary to have the corresponding private key
                        // to cast votes in the side chain
                        voting_key = inspect_voting_key(metamap).map_or_else(
                            |err| {
                                errors_report.push(format!(
                                    "Invalid voting key {} {err}",
                                    hex::encode(raw_cbor)
                                ));
                                None
                            },
                            Some,
                        );

                        // A stake address for the network that this transaction is submitted to (to
                        // point to the Ada that is being delegated);
                        stake_key = inspect_stake_key(metamap).map_or_else(
                            |err| {
                                errors_report.push(format!(
                                    "Invalid stake key {} {err}",
                                    hex::encode(raw_cbor)
                                ));
                                None
                            },
                            Some,
                        );

                        // A Shelley payment address (see CIP-0019) discriminated for the same
                        // network this transaction is submitted to, to
                        // receive rewards.
                        rewards_address = inspect_rewards_addr(metamap, network).map_or_else(
                            |err| {
                                errors_report.push(format!(
                                    "Invalid rewards address {} {err}",
                                    hex::encode(raw_cbor)
                                ));
                                None
                            },
                            |val| Some(RewardsAddress(val.clone())),
                        );

                        // A nonce that identifies that most recent delegation
                        nonce = inspect_nonce(metamap).map_or_else(
                            |err| {
                                errors_report
                                    .push(format!("Invalid nonce {} {err}", hex::encode(raw_cbor)));
                                None
                            },
                            Some,
                        );

                        // A non-negative integer that indicates the purpose of the vote.
                        // This is an optional field to allow for compatibility with CIP-15
                        // 4 entries inside metadata map with one optional entry for the voting
                        // purpose
                        match inspect_voting_purpose(metamap) {
                            Ok(Some(value)) => voting_purpose = Some(value),
                            Ok(None) => voting_purpose = None,
                            Err(err) => {
                                voting_purpose = None;
                                errors_report.push(format!(
                                    "Invalid voting purpose {} {err}",
                                    hex::encode(raw_cbor)
                                ));
                            },
                        };
                    },

                    CIP36_61285 => {
                        // Validate 61285 signature
                        let raw_cbor = cip36_registration
                            .encode_fragment()
                            .map_err(|e| anyhow::anyhow!("{e}"))?;

                        match raw_sig_conversion(
                            &cip36_registration
                                .encode_fragment()
                                .map_err(|e| anyhow::anyhow!("{e}"))?,
                        ) {
                            Ok(sig) => {
                                signature = Some(sig);
                            },
                            Err(err) => {
                                errors_report.push(format!(
                                    "Invalid signature. cbor: {} {err}",
                                    hex::encode(raw_cbor),
                                ));
                                signature = None;
                            },
                        };
                    },
                    _ => continue,
                };
            }
        };

        Ok(Some(Self {
            voting_key,
            stake_key,
            rewards_address,
            nonce,
            voting_purpose,
            raw_cbor_cip36,
            signature,
            errors_report,
        }))
    }
}

/// Validate raw registration binary against 61284 CDDL spec
///
/// # Errors
///
/// Failure will occur if parsed keys do not match CDDL spec
pub fn validate_reg_cddl(bin_reg: &[u8], cddl_config: &CddlConfig) -> anyhow::Result<()> {
    cddl::validate_cbor_from_slice(&cddl_config.cip_36, bin_reg, None)?;

    Ok(())
}

/// Reward addresses start with a single header byte identifying their type and the
/// network, followed by 28 bytes of payload identifying either a stake key hash or a
/// script hash. Function accepts this first header prefix byte.
/// Validates first nibble is within the address range: 0x0? - 0x7? + 0xE? , 0xF?
/// Validates second nibble matches network id: 0/1
#[must_use]
fn is_valid_rewards_address(rewards_address_prefix: u8, network: Network) -> bool {
    let addr_type = rewards_address_prefix >> 4 & 0xF;
    let addr_net = rewards_address_prefix & 0xF;

    // 0 or 1 are valid addrs in the following cases:
    // type = 0x0 -  Testnet network
    // type = 0x1 -  Mainnet network
    match network {
        Network::Mainnet => {
            if addr_net != 1 {
                return false;
            }
        },
        Network::Testnet => {
            if addr_net != 0 {
                return false;
            }
        },
        _ => (),
    }

    // Valid addrs: 0x0?, 0x1?, 0x2?, 0x3?, 0x4?, 0x5?, 0x6?, 0x7?, 0xE?, 0xF?.
    let valid_addrs = [0, 1, 2, 3, 4, 5, 6, 7, 14, 15];
    valid_addrs.contains(&addr_type)
}

/// Convert raw 61285 cbor to witness signature
fn raw_sig_conversion(raw_cbor: &[u8]) -> anyhow::Result<Signature> {
    let decoded: ciborium::value::Value = ciborium::de::from_reader(Cursor::new(&raw_cbor))?;

    let signature_61285 = match decoded {
        Value::Map(m) => m.iter().map(|entry| entry.1.clone()).collect::<Vec<_>>(),
        _ => return Err(anyhow::anyhow!("Invalid signature {decoded:?}")),
    };

    let sig = signature_61285
        .first()
        .ok_or(anyhow::anyhow!("no 61285 key"))?
        .clone();
    let sig_bytes: [u8; 64] = match sig.into_bytes() {
        Ok(s) => {
            match s.try_into() {
                Ok(sig) => sig,
                Err(err) => return Err(anyhow::anyhow!("Invalid signature length {err:?}")),
            }
        },
        Err(err) => return Err(anyhow::anyhow!("Invalid signature parsing {err:?}")),
    };

    Ok(Signature::from_bytes(&sig_bytes))
}

#[allow(clippy::manual_let_else)]
/// Parse cip36 registration tx
fn inspect_metamap_reg(spec_61284: &[Value]) -> anyhow::Result<&Vec<(Value, Value)>> {
    let metamap = match &spec_61284
        .get(KEY_61284)
        .ok_or(anyhow::anyhow!("Issue parsing 61284 parent key"))?
    {
        Value::Map(metamap) => metamap,
        _ => {
            return Err(anyhow::anyhow!(
                "Invalid metamap {:?}",
                spec_61284
                    .get(KEY_61284)
                    .ok_or(anyhow::anyhow!("Issue parsing metamap"))?
            ))
        },
    };
    Ok(metamap)
}

#[allow(clippy::manual_let_else)]
/// Extract voting key
fn inspect_voting_key(metamap: &[(Value, Value)]) -> anyhow::Result<VotingInfo> {
    let voting_key = match &metamap
        .get(DELEGATIONS_OR_DIRECT)
        .ok_or(anyhow::anyhow!("Issue with voting key 61284 cbor parsing"))?
    {
        (Value::Integer(_one), Value::Bytes(direct)) => VotingInfo::Direct(PubKey(direct.clone())),
        (Value::Integer(_one), Value::Array(delegations)) => {
            let mut delegations_map: Vec<(PubKey, i64)> = Vec::new();
            for d in delegations {
                match d {
                    Value::Array(delegations) => {
                        let voting_key = match delegations
                            .get(VOTE_KEY)
                            .ok_or(anyhow::anyhow!("Issue parsing delegations"))?
                            .as_bytes()
                        {
                            Some(key) => key,
                            None => return Err(anyhow::anyhow!("Invalid voting key")),
                        };

                        let weight = match delegations
                            .get(WEIGHT)
                            .ok_or(anyhow::anyhow!("Issue parsing weight"))?
                            .as_integer()
                        {
                            Some(weight) => {
                                match weight.try_into() {
                                    Ok(weight) => weight,
                                    Err(_err) => {
                                        return Err(anyhow::anyhow!("Invalid weight in delegation"))
                                    },
                                }
                            },
                            None => return Err(anyhow::anyhow!("Invalid delegation")),
                        };

                        delegations_map.push(((PubKey(voting_key.clone())), weight));
                    },

                    _ => return Err(anyhow::anyhow!("Invalid voting key")),
                }
            }

            VotingInfo::Delegated(delegations_map)
        },

        _ => return Err(anyhow::anyhow!("Invalid signature")),
    };
    Ok(voting_key)
}

/// Extract stake key
fn inspect_stake_key(metamap: &[(Value, Value)]) -> anyhow::Result<PubKey> {
    let stake_key = match &metamap
        .get(STAKE_ADDRESS)
        .ok_or(anyhow::anyhow!("Issue with stake key parsing"))?
    {
        (Value::Integer(_two), Value::Bytes(stake_addr)) => PubKey(stake_addr.clone()),
        _ => return Err(anyhow::anyhow!("Invalid stake key")),
    };
    Ok(stake_key)
}

/// Extract and validate rewards address
fn inspect_rewards_addr(
    metamap: &[(Value, Value)], network_id: Network,
) -> anyhow::Result<&Vec<u8>> {
    let (Value::Integer(_three), Value::Bytes(rewards_address)) = &metamap
        .get(PAYMENT_ADDRESS)
        .ok_or(anyhow::anyhow!("Issue with rewards address parsing"))?
    else {
        return Err(anyhow::anyhow!("Invalid rewards address"));
    };

    if !is_valid_rewards_address(
        *rewards_address
            .get(NETWORK_ID)
            .ok_or(anyhow::anyhow!("Cannot get network id byte"))?,
        network_id,
    ) {
        return Err(anyhow::anyhow!("Invalid reward address"));
    }
    Ok(rewards_address)
}

/// Extract Nonce
fn inspect_nonce(metamap: &[(Value, Value)]) -> anyhow::Result<Nonce> {
    let nonce: i128 = match metamap
        .get(NONCE)
        .ok_or(anyhow::anyhow!("Issue with nonce parsing"))?
    {
        (Value::Integer(_four), Value::Integer(nonce)) => i128::from(*nonce),
        _ => return Err(anyhow::anyhow!("Invalid nonce")),
    };

    Ok(Nonce(nonce.try_into()?))
}

/// Extract optional voting purpose
fn inspect_voting_purpose(metamap: &[(Value, Value)]) -> anyhow::Result<Option<VotingPurpose>> {
    if metamap.len() == 5 {
        match metamap
            .get(VOTE_PURPOSE)
            .ok_or(anyhow::anyhow!("Issue with voting purpose parsing"))?
        {
            (Value::Integer(_five), Value::Integer(purpose)) => {
                Ok(Some(VotingPurpose(i128::from(*purpose).try_into()?)))
            },
            _ => Ok(None),
        }
    } else {
        Ok(None)
    }
}

#[cfg(test)]
#[test]
fn test_rewards_addr_permutations() {
    // Valid addrs: 0x0?, 0x1?, 0x2?, 0x3?, 0x4?, 0x5?, 0x6?, 0x7?, 0xE?, 0xF?.

    let valid_addr_types = vec![0, 1, 2, 3, 4, 5, 6, 7, 14, 15];

    for addr_type in valid_addr_types {
        let test_addr = addr_type << 4;
        assert!(is_valid_rewards_address(test_addr, Network::Testnet));
        assert!(!is_valid_rewards_address(test_addr, Network::Mainnet));

        let test_addr = addr_type << 4 | 1;
        assert!(!is_valid_rewards_address(test_addr, Network::Testnet));
        assert!(is_valid_rewards_address(test_addr, Network::Mainnet));
    }

    let invalid_addr_types = vec![8, 9, 10, 11, 12, 13];

    for addr_type in invalid_addr_types {
        let test_addr = addr_type << 4;
        assert!(!is_valid_rewards_address(test_addr, Network::Testnet));
        assert!(!is_valid_rewards_address(test_addr, Network::Mainnet));

        let test_addr = addr_type << 4 | 1;
        assert!(!is_valid_rewards_address(test_addr, Network::Testnet));
        assert!(!is_valid_rewards_address(test_addr, Network::Mainnet));
    }
}
