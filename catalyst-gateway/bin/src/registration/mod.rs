//! Verify registration TXs

use cardano_chain_follower::Network;
use ciborium::Value;
use ed25519_dalek::Signature;

use pallas::ledger::primitives::Fragment;
use pallas::ledger::traverse::MultiEraMeta;

use serde::{Deserialize, Serialize};
use std::error::Error;
use std::io::Cursor;

/// Networks
const NETWORK_ID: usize = 0;

/// Cip36 - 61284 entries
const KEY_61284: usize = 0;

/// Cip36
const STAKE_ADDRESS: usize = 1;
///Cip36
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

/// <https://cips.cardano.org/cips/cip36/schema.cddl>
const CIP36_61284: usize = 61284;
/// <https://cips.cardano.org/cips/cip36/schema.cddl>
const CIP36_61285: usize = 61285;

/// Pub key
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub struct PubKey(pub Vec<u8>);

/// Nonce
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub struct Nonce(pub u64);

/// Voting purpose
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub struct VotingPurpose(pub u64);

/// Rewards address
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub struct RewardsAddress(pub Vec<u8>);

/// Stake key
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub struct StakeKey(pub PubKey);

/// Error report for serializing
pub type ErrorReport = Vec<String>;

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

impl Default for CddlConfig {
    fn default() -> Self {
        Self::new()
    }
}

/// A catalyst registration on Cardano in either CIP-15 or CIP-36 format
#[derive(Debug, Clone, PartialEq)]
pub struct Registration {
    /// Voting key
    pub voting_key: Option<VotingKey>,
    /// Stake key
    pub stake_key: Option<StakeKey>,
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
}

/// The source of voting power for a given registration
///
/// The voting power can either come from:
///  - a single wallet, OR
///  - a set of delegations
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
#[derive(Debug, Clone, PartialEq)]
pub enum VotingKey {
    /// Direct voting
    ///
    /// Voting power is based on the staked ada of the given key
    Direct(PubKey),

    /// Delegated voting
    ///
    /// Voting power is based on the staked ada of the delegated keys
    /// order of elements is important and must be preserved.
    Delegated(Vec<(PubKey, u64)>),
}

impl Default for VotingKey {
    fn default() -> Self {
        VotingKey::Direct(PubKey(Vec::new()))
    }
}

/// Validate raw registration binary against 61284 CDDL spec
///
/// # Errors
///
/// Failure will occur if parsed keys do not match CDDL spec
pub fn validate_reg_cddl(bin_reg: &[u8], cddl_config: &CddlConfig) -> Result<(), Box<dyn Error>> {
    cddl::validate_cbor_from_slice(&cddl_config.cip_36, bin_reg, None)?;

    Ok(())
}

/// Reward addresses start with a single header byte identifying their type and the network,
/// followed by 28 bytes of payload identifying either a stake key hash or a script hash.
/// Function accepts this first header prefix byte.
/// Validates first nibble is within the address range: 0x0? - 0x7? + 0xE? , 0xF?
/// Validates second nibble matches network id: 0/1
#[must_use]
pub fn is_valid_rewards_address(rewards_address_prefix: u8, network: Network) -> bool {
    let addr_type = rewards_address_prefix >> 4 & 0xf;
    let addr_net = rewards_address_prefix & 0xf;

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
pub fn raw_sig_conversion(raw_cbor: &[u8]) -> Result<Signature, Box<dyn Error>> {
    let decoded: ciborium::value::Value = ciborium::de::from_reader(Cursor::new(&raw_cbor))?;

    let signature_61285 = match decoded {
        Value::Map(m) => m.iter().map(|entry| entry.1.clone()).collect::<Vec<_>>(),
        _ => return Err(format!("Invalid signature {decoded:?}").into()),
    };

    let sig = signature_61285.first().ok_or("no 61285 key")?.clone();
    let s: [u8; 64] = match sig.into_bytes() {
        Ok(s) => s.try_into().unwrap_or([0; 64]),
        Err(err) => return Err(format!("Invalid signature parsing {err:?}").into()),
    };

    Ok(Signature::from_bytes(&s))
}

#[allow(clippy::manual_let_else)]
/// Parse cip36 registration tx
pub fn inspect_metamap_reg(spec_61284: &[Value]) -> Result<&Vec<(Value, Value)>, Box<dyn Error>> {
    let metamap = match &spec_61284[0] {
        Value::Map(metamap) => metamap,
        _ => return Err(format!("Invalid metamap {:?}", spec_61284[KEY_61284]).into()),
    };
    Ok(metamap)
}

#[allow(clippy::manual_let_else)]
/// Extract voting key
pub fn inspect_voting_key(metamap: &[(Value, Value)]) -> Result<VotingKey, Box<dyn Error>> {
    let voting_key = match &metamap[DELEGATIONS_OR_DIRECT] {
        (Value::Integer(_one), Value::Bytes(direct)) => VotingKey::Direct(PubKey(direct.clone())),
        (Value::Integer(_one), Value::Array(delegations)) => {
            let mut delegations_map: Vec<(PubKey, u64)> = Vec::new();
            for d in delegations {
                match d {
                    Value::Array(delegations) => {
                        let voting_key = match delegations[VOTE_KEY].as_bytes() {
                            Some(key) => key,
                            None => return Err("Invalid voting key".to_string().into()),
                        };

                        let weight = match delegations[WEIGHT].as_integer() {
                            Some(weight) => match weight.try_into() {
                                Ok(weight) => weight,
                                Err(_err) => {
                                    return Err("Invalid weight in delegation".to_string().into())
                                },
                            },
                            None => return Err("Invalid delegation".to_string().into()),
                        };

                        delegations_map.push(((PubKey(voting_key.clone())), weight));
                    },

                    _ => return Err("Invalid voting key".to_string().into()),
                }
            }

            VotingKey::Delegated(delegations_map)
        },

        _ => return Err("Invalid signature".to_string().into()),
    };
    Ok(voting_key)
}

/// Extract stake key
pub fn inspect_stake_key(metamap: &[(Value, Value)]) -> Result<PubKey, Box<dyn Error>> {
    let stake_key = match &metamap[STAKE_ADDRESS] {
        (Value::Integer(_two), Value::Bytes(stake_addr)) => PubKey(stake_addr.clone()),
        _ => return Err("Invalid stake key".to_string().into()),
    };
    Ok(stake_key)
}

/// Extract and validate rewards address
pub fn inspect_rewards_addr(
    metamap: &[(Value, Value)], network_id: Network,
) -> Result<&Vec<u8>, Box<dyn Error>> {
    let (Value::Integer(_three), Value::Bytes(rewards_address)) = &metamap[PAYMENT_ADDRESS] else {
        return Err("Invalid rewardsd address".to_string().into());
    };

    if !is_valid_rewards_address(*rewards_address.get(NETWORK_ID).ok_or("err")?, network_id) {
        return Err("Invalid reward address".to_string().into());
    }
    Ok(rewards_address)
}

/// Extract Nonce
pub fn inspect_nonce(metamap: &[(Value, Value)]) -> Result<Nonce, Box<dyn Error>> {
    let nonce = match metamap[NONCE] {
        (Value::Integer(_four), Value::Integer(nonce)) => Nonce(nonce.try_into()?),
        _ => return Err("Invalid nonce".to_string().into()),
    };
    Ok(nonce)
}

/// Extract optional voting purpose
pub fn inspect_voting_purpose(
    metamap: &[(Value, Value)],
) -> Result<Option<VotingPurpose>, Box<dyn Error>> {
    if metamap.len() == 5 {
        match metamap[VOTE_PURPOSE] {
            (Value::Integer(_five), Value::Integer(purpose)) => {
                Ok(Some(VotingPurpose(purpose.try_into()?)))
            },
            _ => Ok(None),
        }
    } else {
        Ok(None)
    }
}

/// Extract registrations information for TX metadata
/// Collect secondary errors for granular json error report
pub fn parse_registrations_from_metadata(
    meta: &MultiEraMeta, network: Network,
) -> Result<(Registration, ErrorReport), Box<dyn Error>> {
    let mut voting_key: Option<VotingKey> = None;
    let mut stake_key: Option<StakeKey> = None;
    let mut voting_purpose: Option<VotingPurpose> = None;
    let mut rewards_address: Option<RewardsAddress> = None;
    let mut nonce: Option<Nonce> = None;
    let mut raw_cbor_cip36: Option<Vec<u8>> = None;
    let mut sig: Option<Signature> = None;

    let mut errors_report = Vec::new();

    if let pallas::ledger::traverse::MultiEraMeta::AlonzoCompatible(meta) = meta {
        for (key, cip36_registration) in meta.iter() {
            if *key == u64::try_from(CIP36_61284)? {
                let raw_cbor = meta.encode_fragment()?;
                raw_cbor_cip36 = Some(raw_cbor.clone());

                let decoded: ciborium::value::Value =
                    ciborium::de::from_reader(Cursor::new(&raw_cbor))?;

                let meta_61284 = if let Value::Map(m) = decoded {
                    m.iter().map(|entry| entry.1.clone()).collect::<Vec<_>>()
                } else {
                    errors_report.push(format!("61284 parent cddl invalid {decoded:?}"));
                    continue;
                };

                // 4 entries inside metadata map with one optional entry for the voting purpose
                let metamap = match inspect_metamap_reg(&meta_61284) {
                    Ok(value) => value,
                    Err(err) => {
                        errors_report
                            .push(format!("61284 child cddl invalid {raw_cbor:?} {err:?}"));
                        continue;
                    },
                };

                // voting key: simply an ED25519 public key. This is the spending credential in the sidechain that will receive voting power
                // from this delegation. For direct voting it's necessary to have the corresponding private key to cast votes in the sidechain
                match inspect_voting_key(metamap) {
                    Ok(value) => voting_key = Some(value),
                    Err(err) => {
                        voting_key = None;
                        errors_report.push(format!("Invalid voting key {raw_cbor:?} {err:?}"));
                    },
                };

                // A stake address for the network that this transaction is submitted to (to point to the Ada that is being delegated);
                match inspect_stake_key(metamap) {
                    Ok(value) => stake_key = Some(StakeKey(value)),
                    Err(err) => {
                        stake_key = None;
                        errors_report.push(format!("Invalid stake key {raw_cbor:?} {err:?}"));
                    },
                };

                // A Shelley payment address (see CIP-0019) discriminated for the same network
                // this transaction is submitted to, to receive rewards.
                match inspect_rewards_addr(metamap, network) {
                    Ok(value) => rewards_address = Some(RewardsAddress(value.clone())),
                    Err(err) => {
                        rewards_address = None;
                        errors_report.push(format!("Invalid rewards address {raw_cbor:?} {err:?}"));
                    },
                };

                // A nonce that identifies that most recent delegation
                match inspect_nonce(metamap) {
                    Ok(value) => nonce = Some(value),
                    Err(err) => {
                        errors_report.push(format!("Invalid nonce {raw_cbor:?} {err:?}"));
                        nonce = None;
                    },
                };

                // A non-negative integer that indicates the purpose of the vote.
                // This is an optional field to allow for compatibility with CIP-15
                // 4 entries inside metadata map with one optional entry for the voting purpose
                match inspect_voting_purpose(metamap) {
                    Ok(Some(value)) => voting_purpose = Some(value),
                    Ok(None) => voting_purpose = None,
                    Err(err) => {
                        voting_purpose = None;
                        errors_report.push(format!("Invalid voting purpose {raw_cbor:?} {err:?}"));
                    },
                };
            } else if *key == u64::try_from(CIP36_61285)? {
                // Validate 61285 signature
                let raw_cbor = cip36_registration.encode_fragment()?;

                match raw_sig_conversion(&cip36_registration.encode_fragment()?) {
                    Ok(signature) => {
                        sig = Some(signature);
                    },
                    Err(err) => {
                        errors_report.push(format!(
                            "Invalid signature. cbor: {:?} {:?}",
                            hex::encode(raw_cbor),
                            err
                        ));
                        sig = None;
                    },
                };
            }
        }
    };

    let r = Registration {
        voting_key,
        stake_key,
        rewards_address,
        nonce,
        voting_purpose,
        raw_cbor_cip36,
        signature: sig,
    };

    Ok((r, errors_report))
}

#[cfg(test)]
#[test]
pub fn test_rewards_addr_permuations() {
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
