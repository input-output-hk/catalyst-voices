//! Verify registration TXs

use cardano_chain_follower::Network;
use ciborium::Value;
use cryptoxide::{blake2b::Blake2b, digest::Digest};
use pallas::ledger::{
    primitives::{conway::Metadatum, Fragment},
    traverse::MultiEraMeta,
};
use serde::{Deserialize, Serialize};

/// Pub key
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub(crate) struct PubKey(Vec<u8>);

/// Nonce
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub(crate) struct Nonce(pub i64);

/// Voting purpose
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Default)]
pub(crate) struct VotingPurpose(u64);

/// Rewards address
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub(crate) struct RewardsAddress(pub Vec<u8>);

/// Error report for serializing
pub(crate) type ErrorReport = Vec<String>;

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
    r: [u8; Self::COMPONENT_SIZE],
    /// Component of an Ed25519 signature when serialized as bytes
    s: [u8; Self::COMPONENT_SIZE],
}

impl Signature {
    /// Size of an encoded Ed25519 signature in bytes.
    const BYTE_SIZE: usize = Self::COMPONENT_SIZE * 2;
    /// Size of a single component of an Ed25519 signature.
    const COMPONENT_SIZE: usize = 32;

    /// Parse an Ed25519 signature from a byte slice.
    fn from_bytes(bytes: &[u8; Self::BYTE_SIZE]) -> Self {
        let mut r = <[u8; Self::COMPONENT_SIZE]>::default();
        let mut s = <[u8; Self::COMPONENT_SIZE]>::default();

        let components = bytes.split_at(Self::COMPONENT_SIZE);
        r.copy_from_slice(components.0);
        s.copy_from_slice(components.1);

        Self { r, s }
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
    /// Voting info
    pub voting_info: Option<VotingInfo>,
    /// Stake key
    pub stake_key: Option<PubKey>,
    /// Rewards address
    pub rewards_address: Option<RewardsAddress>,
    /// Nonce
    pub nonce: Option<Nonce>,
    /// Optional voting purpose
    pub voting_purpose: Option<VotingPurpose>,
    /// Raw tx metadata
    pub raw_metadata: Option<Vec<u8>>,
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
    ) -> Option<Self> {
        if tx_metadata.is_empty() {
            return None;
        }

        let mut voting_info: Option<VotingInfo> = None;
        let mut stake_key: Option<PubKey> = None;
        let mut voting_purpose: Option<VotingPurpose> = None;
        let mut rewards_address: Option<RewardsAddress> = None;
        let mut nonce: Option<Nonce> = None;
        let mut raw_metadata: Option<Vec<u8>> = None;
        let mut signature: Option<Signature> = None;
        let mut errors_report = Vec::new();

        if let pallas::ledger::traverse::MultiEraMeta::AlonzoCompatible(tx_metadata) = tx_metadata {
            /// <https://cips.cardano.org/cips/cip36>
            const CIP36_REGISTRATION_CBOR_KEY: u64 = 61284;
            /// <https://cips.cardano.org/cips/cip36>
            const CIP36_WITNESS_CBOR_KEY: u64 = 61285;

            raw_metadata = tx_metadata.encode_fragment().map_or_else(
                |err| {
                    errors_report.push(format!("cannot encode tx metadata into bytes {err}"));
                    None
                },
                Some,
            );
            for (key, metadata) in tx_metadata.iter() {
                match *key {
                    CIP36_REGISTRATION_CBOR_KEY => {
                        let cbor_value = match convert_pallas_metadatum_to_cbor_value(metadata) {
                            Ok(raw_cbor) => raw_cbor,
                            Err(err) => {
                                errors_report.push(err.to_string());
                                continue;
                            },
                        };

                        let Some(cbor_map) = cbor_value.as_map() else {
                            errors_report.push(
                                "Not a valid cbor cip36 registration, should be a cbor map"
                                    .to_string(),
                            );
                            continue;
                        };

                        // voting key: simply an ED25519 public key. This is the spending credential
                        // in the side chain that will receive voting power
                        // from this delegation. For direct voting it's
                        // necessary to have the corresponding private key
                        // to cast votes in the side chain
                        voting_info = inspect_voting_info(cbor_map).map_or_else(
                            |err| {
                                errors_report.push(format!("Invalid voting key, err: {err}",));
                                None
                            },
                            Some,
                        );

                        // A stake address for the network that this transaction is submitted to (to
                        // point to the Ada that is being delegated);
                        stake_key = inspect_stake_key(cbor_map).map_or_else(
                            |err| {
                                errors_report.push(format!("Invalid stake key, err: {err}",));
                                None
                            },
                            Some,
                        );

                        // A Shelley payment address (see CIP-0019) discriminated for the same
                        // network this transaction is submitted to, to
                        // receive rewards.
                        rewards_address = inspect_rewards_addr(cbor_map, network).map_or_else(
                            |err| {
                                errors_report.push(format!("Invalid rewards address, err: {err}",));
                                None
                            },
                            |val| Some(RewardsAddress(val.clone())),
                        );

                        nonce = inspect_nonce(cbor_map).map_or_else(
                            |err| {
                                errors_report.push(format!("Invalid nonce, err: {err}",));
                                None
                            },
                            Some,
                        );

                        voting_purpose = inspect_voting_purpose(cbor_map).map_or_else(
                            |err| {
                                errors_report.push(format!("Invalid voting purpose, err: {err}",));
                                None
                            },
                            Some,
                        );
                    },
                    CIP36_WITNESS_CBOR_KEY => {
                        let cbor_value = match convert_pallas_metadatum_to_cbor_value(metadata) {
                            Ok(raw_cbor) => raw_cbor,
                            Err(err) => {
                                errors_report.push(err.to_string());
                                continue;
                            },
                        };

                        signature = inspect_signature(cbor_value).map_or_else(
                            |err| {
                                errors_report.push(format!("Invalid signature, err: {err}",));
                                None
                            },
                            Some,
                        );
                    },
                    _ => continue,
                };
            }
        };

        Some(Self {
            voting_info,
            stake_key,
            rewards_address,
            nonce,
            voting_purpose,
            raw_metadata,
            signature,
            errors_report,
        })
    }
}

/// Convert Pallas Metadatum to Cbor Value
fn convert_pallas_metadatum_to_cbor_value(metadata: &Metadatum) -> anyhow::Result<ciborium::Value> {
    let metadata_bytes = metadata
        .encode_fragment()
        .map_err(|err| anyhow::anyhow!("cannot encode metadata into bytes {err}"))?;

    ciborium::de::from_reader(metadata_bytes.as_slice())
        .map_err(|err| anyhow::anyhow!("Cannot decode cbor object from bytes, err: {err}"))
}

/// Validate binary data against CIP-36 registration CDDL spec
#[allow(dead_code)]
fn validate_cip36_registration(data: &[u8]) -> anyhow::Result<()> {
    /// Cip36 registration CDDL definition
    const CIP36_REGISTRATION_CDDL: &str = include_str!("cip36_registration.cddl");

    cddl::validate_cbor_from_slice(CIP36_REGISTRATION_CDDL, data, None)?;
    Ok(())
}

/// Validate binary data against CIP-36 registration CDDL spec
#[allow(dead_code)]
fn validate_cip36_witness(data: &[u8]) -> anyhow::Result<()> {
    /// Cip36 witness CDDL definition
    const CIP36_WITNESS_CDDL: &str = include_str!("cip36_witness.cddl");

    cddl::validate_cbor_from_slice(CIP36_WITNESS_CDDL, data, None)?;
    Ok(())
}

/// Reward addresses start with a single header byte identifying their type and the
/// network, followed by 28 bytes of payload identifying either a stake key hash or a
/// script hash. Function accepts this first header prefix byte.
/// Validates first nibble is within the address range: 0x0? - 0x7? + 0xE? , 0xF?
/// Validates second nibble matches network id: 0/1
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

/// Extract signature
fn inspect_signature(cbor_value: ciborium::value::Value) -> anyhow::Result<Signature> {
    let cbor_map = cbor_value
        .into_map()
        .map_err(|_| anyhow::anyhow!("Invalid cip36 witness cbor, should be a map"))?;

    let (_, cbor_signature) = cbor_map.into_iter().next().ok_or(anyhow::anyhow!(
        "Invalid cip36 witness cbor, should have at least one entry"
    ))?;

    let signature = cbor_signature
        .into_bytes()
        .map_err(|_| anyhow::anyhow!("Invalid cip36 witness cbor, signature should be bytes"))?
        .try_into()
        .map_err(|vec: Vec<_>| {
            anyhow::anyhow!(
                "Invalid signature length, expected: {}, got {}",
                Signature::BYTE_SIZE,
                vec.len()
            )
        })?;

    Ok(Signature::from_bytes(&signature))
}

/// Extract voting info
fn inspect_voting_info(cbor_map: &[(Value, Value)]) -> anyhow::Result<VotingInfo> {
    /// Voting info cbor key
    const VOTING_INFO_CBOR_KEY: usize = 0;
    /// Voting key cbor key
    const VOTE_KEY_CBOR_KEY: usize = 0;
    /// Weight cbor key
    const WEIGHT_CBOR_KEY: usize = 1;

    let voting_key = match cbor_map.get(VOTING_INFO_CBOR_KEY).ok_or(anyhow::anyhow!(
        "Issue with registration voting info cbor parsing"
    ))? {
        (Value::Integer(_), Value::Bytes(direct)) => VotingInfo::Direct(PubKey(direct.clone())),
        (Value::Integer(_), Value::Array(cbor_array)) => {
            let mut delegations = Vec::new();
            for cbor_value in cbor_array {
                let delegation_info = cbor_value.as_array().ok_or(anyhow::anyhow!(
                    "Invalid delegations, should be a cbor array"
                ))?;

                let voting_key = delegation_info
                    .get(VOTE_KEY_CBOR_KEY)
                    .ok_or(anyhow::anyhow!("Issue parsing delegation key"))?
                    .as_bytes()
                    .ok_or(anyhow::anyhow!("Issue parsing delegation key"))?;

                let weight = delegation_info
                    .get(WEIGHT_CBOR_KEY)
                    .ok_or(anyhow::anyhow!("Issue parsing delegation weight"))?
                    .as_integer()
                    .ok_or(anyhow::anyhow!("Issue parsing delegation weight"))?
                    .try_into()?;

                delegations.push(((PubKey(voting_key.clone())), weight));
            }

            VotingInfo::Delegated(delegations)
        },

        _ => return Err(anyhow::anyhow!("Missing voting info")),
    };
    Ok(voting_key)
}

/// Extract stake key
fn inspect_stake_key(cbor_map: &[(Value, Value)]) -> anyhow::Result<PubKey> {
    /// Stake key cbor key
    const STAKE_ADDRESS_CBOR_KEY: usize = 1;

    let stake_key = match cbor_map
        .get(STAKE_ADDRESS_CBOR_KEY)
        .ok_or(anyhow::anyhow!("Issue with stake key parsing"))?
    {
        (Value::Integer(_two), Value::Bytes(stake_addr)) => PubKey(stake_addr.clone()),
        _ => return Err(anyhow::anyhow!("Missing stake key")),
    };
    Ok(stake_key)
}

/// Extract and validate rewards address
fn inspect_rewards_addr(
    cbor_map: &[(Value, Value)], network_id: Network,
) -> anyhow::Result<&Vec<u8>> {
    /// Payment address cbor key
    const PAYMENT_ADDRESS_CBOR_KEY: usize = 2;

    let (Value::Integer(_three), Value::Bytes(rewards_address)) = &cbor_map
        .get(PAYMENT_ADDRESS_CBOR_KEY)
        .ok_or(anyhow::anyhow!("Issue with rewards address parsing"))?
    else {
        return Err(anyhow::anyhow!("Invalid rewards address"));
    };

    let network_prefix = rewards_address.first().ok_or(anyhow::anyhow!(
        "Invalid rewards address, missing network prefix"
    ))?;
    if !is_valid_rewards_address(*network_prefix, network_id) {
        return Err(anyhow::anyhow!("Invalid reward address"));
    }
    Ok(rewards_address)
}

/// Extract Nonce
fn inspect_nonce(cbor_map: &[(Value, Value)]) -> anyhow::Result<Nonce> {
    /// Nonce cbor key
    const NONCE_CBOR_KEY: usize = 3;

    match cbor_map
        .get(NONCE_CBOR_KEY)
        .ok_or(anyhow::anyhow!("Issue with nonce parsing"))?
    {
        (Value::Integer(_four), Value::Integer(nonce)) => Ok(Nonce(i128::from(*nonce).try_into()?)),
        _ => Err(anyhow::anyhow!("Missing nonce")),
    }
}

/// Extract optional voting purpose
fn inspect_voting_purpose(metamap: &[(Value, Value)]) -> anyhow::Result<VotingPurpose> {
    /// Voting purpose cbor key
    const VOTING_PURPOSE_CBOR_KEY: usize = 4;

    // A non-negative integer that indicates the purpose of the vote.
    // This is an optional field to allow for compatibility with CIP-15
    // 4 entries inside metadata map with one optional entry for the voting
    // purpose
    match metamap.get(VOTING_PURPOSE_CBOR_KEY) {
        Some((Value::Integer(_five), Value::Integer(purpose))) => {
            Ok(VotingPurpose(i128::from(*purpose).try_into()?))
        },
        Some(_) => Err(anyhow::anyhow!("Missing voting purpose")),
        None => Ok(VotingPurpose::default()),
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
