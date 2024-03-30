//! Verify registration TXs

use cardano_chain_follower::Network;
use ciborium::Value;
use ed25519_dalek::Signature;

use serde::{Deserialize, Serialize};
use std::error::Error;
use std::io::Cursor;

// Networks
const NETWORK_ID: usize = 0;

// 61284 entries
const KEY_61284: usize = 0;
const DELEGATIONS_OR_DIRECT: usize = 0;
const STAKE_ADDRESS: usize = 1;
const PAYMENT_ADDRESS: usize = 2;
const NONCE: usize = 3;
const VOTE_PURPOSE: usize = 4;

const VOTE_KEY: usize = 0;
const WEIGHT: usize = 1;

// 61285
//const KEY_61285: usize = 0;
//const WITNESS: usize = 0;

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub struct PubKey(pub Vec<u8>);

pub type Nonce = u64;
pub type VotingPurpose = u64;
pub type RewardsAddress = Vec<u8>;
pub type StakeKey = PubKey;

/// A catalyst registration on Cardano in either CIP-15 or CIP-36 format
#[derive(Debug, Serialize, Deserialize, Clone, PartialEq, Default)]
pub struct Registration {
    pub voting_key: VotingKey,
    pub stake_key: StakeKey,
    pub rewards_address: RewardsAddress,
    pub nonce: Nonce,
    pub voting_purpose: Option<VotingPurpose>,
    pub raw_cbor_61284: Vec<u8>,
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

/// Cddl schema:
/// <https://cips.cardano.org/cips/cip36/schema.cddl>
pub struct CddlConfig {
    pub spec_cip36: String,
}

impl CddlConfig {
    #[must_use]
    pub fn new() -> Self {
        let cddl_36: String = include_str!("cip36.cddl").to_string();

        CddlConfig {
            spec_cip36: cddl_36,
        }
    }
}

impl Default for CddlConfig {
    fn default() -> Self {
        Self::new()
    }
}

/// Validate raw registration binary against 61284+61825 CDDL spec
///
/// # Errors
///
/// Failure will occur if parsed keys do not match CDDL spec
pub fn validate_reg_cddl(bin_reg: &[u8], cddl_config: &CddlConfig) -> Result<(), Box<dyn Error>> {
    cddl::validate_cbor_from_slice(&cddl_config.spec_cip36, bin_reg, None)?;

    Ok(())
}

pub fn raw_sig_conversion(raw_cbor: Vec<u8>) -> Result<Signature, Box<dyn Error>> {
    let decoded: ciborium::value::Value = ciborium::de::from_reader(Cursor::new(&raw_cbor))?;

    let signature_61285 = match decoded {
        Value::Map(m) => m.iter().map(|entry| entry.1.clone()).collect::<Vec<_>>(),
        _ => return Err(format!("Invalid signature {:?}", decoded).into()),
    };

    let x: [u8; 64] = signature_61285
        .iter()
        .find_map(|key| Some(key.clone().into_bytes().unwrap()))
        .unwrap()
        .try_into()
        .unwrap();

    let sig = Signature::from_bytes(&x);

    Ok(sig)
}

#[allow(clippy::manual_let_else)]
pub fn inspect_metamap_reg(spec_61284: &[Value]) -> Result<&Vec<(Value, Value)>, Box<dyn Error>> {
    let metamap = match &spec_61284[0] {
        Value::Map(metamap) => metamap,
        _ => return Err(format!("Invalid signature {:?}", spec_61284[KEY_61284]).into()),
    };
    Ok(metamap)
}

#[allow(clippy::manual_let_else)]
pub fn inspect_voting_key(metamap: &[(Value, Value)]) -> Result<VotingKey, Box<dyn Error>> {
    let voting_key = match &metamap[DELEGATIONS_OR_DIRECT] {
        (Value::Integer(_one), Value::Bytes(direct)) => {
            VotingKey::Direct(PubKey(direct.clone()).into())
        },
        (Value::Integer(_one), Value::Array(delegations)) => {
            let mut delegations_map: Vec<(PubKey, u64)> = Vec::new();
            for d in delegations {
                match d {
                    Value::Array(delegations) => {
                        let voting_key = match delegations[VOTE_KEY].as_bytes() {
                            Some(key) => key,
                            None => return Err(format!("Invalid signature").into()),
                        };

                        let weight = match delegations[WEIGHT].as_integer() {
                            Some(weight) => match weight.try_into() {
                                Ok(weight) => weight,
                                Err(_err) => return Err(format!("Invalid signature").into()),
                            },
                            None => return Err(format!("Invalid signature ").into()),
                        };

                        delegations_map.push(((PubKey(voting_key.clone())), weight));
                    },

                    _ => return Err(format!("Invalid signature").into()),
                }
            }

            VotingKey::Delegated(delegations_map)
        },

        _ => return Err(format!("Invalid signature").into()),
    };
    Ok(voting_key)
}

pub fn inspect_stake_key(metamap: &[(Value, Value)]) -> Result<PubKey, Box<dyn Error>> {
    let stake_key = match &metamap[STAKE_ADDRESS] {
        (Value::Integer(_two), Value::Bytes(stake_addr)) => PubKey(stake_addr.clone()),
        _ => return Err(format!("Invalid signature").into()),
    };
    Ok(stake_key)
}

pub fn inspect_rewards_addr(
    metamap: &[(Value, Value)], network_id: Network,
) -> Result<&Vec<u8>, Box<dyn Error>> {
    let rewards_address = match &metamap[PAYMENT_ADDRESS] {
        (Value::Integer(_three), Value::Bytes(rewards_addr)) => rewards_addr,
        _ => return Err(format!("Invalid signature").into()),
    };

    if !is_valid_rewards_address(&rewards_address.get(NETWORK_ID).unwrap(), network_id) {
        return Err(format!("Invalid signature").into());
    }
    Ok(rewards_address)
}

pub fn inspect_nonce(metamap: &[(Value, Value)]) -> Result<Nonce, Box<dyn Error>> {
    let nonce = match metamap[NONCE] {
        (Value::Integer(_four), Value::Integer(nonce)) => nonce.try_into().unwrap(),
        _ => return Err(format!("Invalid signature").into()),
    };
    Ok(nonce)
}

pub fn inspect_voting_purpose(metamap: &Vec<(Value, Value)>) -> Option<VotingPurpose> {
    if metamap.len() == 5 {
        match metamap[VOTE_PURPOSE] {
            (Value::Integer(_five), Value::Integer(purpose)) => Some(purpose.try_into().unwrap()),
            _ => None,
        }
    } else {
        None
    }
}

/// Reward addresses start with a single header byte identifying their type and the network,
/// followed by 28 bytes of payload identifying either a stake key hash or a script hash.
/// Function accepts this first header prefix byte.
/// Validates first nibble is within the address range: 0x0? - 0x7? + 0xE? , 0xF?
/// Validates second nibble matches network id: 0/1
#[must_use]
pub fn is_valid_rewards_address(rewards_address_prefix: &u8, network: Network) -> bool {
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

#[cfg(test)]
#[test]
pub fn test_rewards_addr_permuations() {
    // Valid addrs: 0x0?, 0x1?, 0x2?, 0x3?, 0x4?, 0x5?, 0x6?, 0x7?, 0xE?, 0xF?.

    let valid_addr_types = vec![0, 1, 2, 3, 4, 5, 6, 7, 14, 15];

    for addr_type in valid_addr_types {
        let test_addr = addr_type << 4;
        assert!(is_valid_rewards_address(&test_addr, Network::Testnet));
        assert!(!is_valid_rewards_address(&test_addr, Network::Mainnet));

        let test_addr = addr_type << 4 | 1;
        assert!(!is_valid_rewards_address(&test_addr, Network::Testnet));
        assert!(is_valid_rewards_address(&test_addr, Network::Mainnet));
    }

    let invalid_addr_types = vec![8, 9, 10, 11, 12, 13];

    for addr_type in invalid_addr_types {
        let test_addr = addr_type << 4;
        assert!(!is_valid_rewards_address(&test_addr, Network::Testnet));
        assert!(!is_valid_rewards_address(&test_addr, Network::Mainnet));

        let test_addr = addr_type << 4 | 1;
        assert!(!is_valid_rewards_address(&test_addr, Network::Testnet));
        assert!(!is_valid_rewards_address(&test_addr, Network::Mainnet));
    }
}
