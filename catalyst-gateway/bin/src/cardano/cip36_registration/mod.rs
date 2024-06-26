//! Verify registration TXs

use anyhow::Ok;
use cardano_chain_follower::Network;
use ciborium::{value::Integer, Value};
use cryptoxide::{blake2b::Blake2b, digest::Digest};
use ed25519_dalek::{Signature, Verifier, VerifyingKey};
use pallas::ledger::{
    primitives::{conway::Metadatum, Fragment},
    traverse::MultiEraMeta,
};
use serde::{Deserialize, Serialize};

use super::util::hash;

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

/// CIP-36 registration info part
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct Registration {
    /// Voting info
    pub(crate) voting_info: VotingInfo,
    /// Stake key
    pub(crate) stake_key: PubKey,
    /// Rewards address
    pub(crate) rewards_address: RewardsAddress,
    /// Nonce
    pub(crate) nonce: Nonce,
    /// Voting purpose
    pub(crate) voting_purpose: VotingPurpose,
}

/// A catalyst CIP-36 registration on Cardano
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct Cip36Metadata {
    /// CIP-36 registration 61284
    pub(crate) registration: Option<Registration>,
    /// CIP-36 witness signature 61285
    pub signature: Option<Signature>,
    /// Errors report
    pub errors_report: ErrorReport,
}

impl Cip36Metadata {
    /// Create new `Cip36Registration` from tx metadata
    /// Collect secondary errors for granular json error report
    pub(crate) fn generate_from_tx_metadata(
        tx_metadata: &MultiEraMeta, network: Network,
    ) -> Option<Self> {
        if tx_metadata.is_empty() {
            return None;
        }

        let mut registration = None;
        let mut signature = None;
        let mut errors_report = Vec::new();

        if let pallas::ledger::traverse::MultiEraMeta::AlonzoCompatible(tx_metadata) = tx_metadata {
            /// <https://cips.cardano.org/cips/cip36>
            const CIP36_REGISTRATION_CBOR_KEY: u64 = 61284;
            /// <https://cips.cardano.org/cips/cip36>
            const CIP36_WITNESS_CBOR_KEY: u64 = 61285;

            let mut raw_61284 = None;

            for (key, metadata) in tx_metadata.iter() {
                match *key {
                    CIP36_REGISTRATION_CBOR_KEY => {
                        registration = inspect_registration_from_metadata(metadata, network)
                            .map_or_else(
                                |err| {
                                    errors_report.push(format!("{err}"));
                                    None
                                },
                                Some,
                            );

                        raw_61284 = original_61284_payload(metadata).map_or_else(
                            |err| {
                                errors_report.push(format!("{err}"));
                                None
                            },
                            Some,
                        );
                    },
                    CIP36_WITNESS_CBOR_KEY => {
                        signature = inspect_witness_from_metadata(metadata).map_or_else(
                            |err| {
                                errors_report.push(format!("{err}"));
                                None
                            },
                            Some,
                        );
                    },
                    _ => continue,
                };
            }

            if let Some(raw_61284) = raw_61284 {
                let _ = validate_signature(&raw_61284, &registration.clone(), &signature).map_err(
                    |err| {
                        errors_report.push(format!("{err}"));
                    },
                );
            }
        };

        Some(Self {
            registration: registration.clone(),
            signature,
            errors_report,
        })
    }
}

/// The signature is generated by:
///  - CBOR encoding the registration
///  - blake2b-256 hashing those bytes
///  - signing the hash with the private key used to generate the stake key
pub fn validate_signature(
    raw_61284: &[u8], registration: &Option<Registration>, signature: &Option<Signature>,
) -> anyhow::Result<()> {
    let hash_bytes = hash(raw_61284);

    let verifying_key = VerifyingKey::from_bytes(
        registration
            .clone()
            .ok_or(anyhow::anyhow!("no registration data"))?
            .stake_key
            .bytes()
            .try_into()?,
    )?;

    let sig = signature.ok_or(anyhow::anyhow!("cannot verify payload without signature"))?;

    Ok(verifying_key.verify(&hash_bytes, &sig)?)
}

/// Validate binary data against CIP-36 registration CDDL spec
fn validate_cip36_registration(data: &[u8]) -> anyhow::Result<()> {
    /// Cip36 registration CDDL definition
    const CIP36_REGISTRATION_CDDL: &str = include_str!("cip36_registration.cddl");

    cddl::validate_cbor_from_slice(CIP36_REGISTRATION_CDDL, data, None)?;
    Ok(())
}

/// Validate binary data against CIP-36 registration CDDL spec
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

/// Extract witness from tx metadata
fn inspect_witness_from_metadata(metadata: &Metadatum) -> anyhow::Result<Signature> {
    let metadata_bytes = metadata
        .encode_fragment()
        .map_err(|err| anyhow::anyhow!("cannot encode metadata into bytes {err}"))?;

    validate_cip36_witness(metadata_bytes.as_slice())?;

    let cbor_value = ciborium::de::from_reader(metadata_bytes.as_slice())
        .map_err(|err| anyhow::anyhow!("Cannot decode cbor object from bytes, err: {err}"))?;

    inspect_signature(cbor_value)
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
            anyhow::anyhow!("Invalid signature length, expected:  got {}", vec.len())
        })?;

    Ok(Signature::from_bytes(&signature))
}

/// Rebuild 61284 from pallas metadata to match original signed 61284 payload, pallas does
/// not preserve exact 61284 bytes which is required for signature verification. It must
/// be rebuilt and re-serialized to perform signature verification.
fn original_61284_payload(metadata: &Metadatum) -> anyhow::Result<Vec<u8>> {
    /// 61284 CIP-36
    const CIP_36_61284: usize = 61284;

    let metadata_bytes = metadata
        .encode_fragment()
        .map_err(|err| anyhow::anyhow!("cannot encode metadata into bytes {err}"))?;

    let cbor_value = ciborium::de::from_reader::<ciborium::Value, _>(metadata_bytes.as_slice())
        .map_err(|err| anyhow::anyhow!("Cannot decode cbor object from bytes, err: {err}"))?;

    let cbor_map = cbor_value.as_map().ok_or(anyhow::anyhow!(
        "Not a valid cbor cip36 registration, should be a map"
    ))?;

    let registration_payload = Value::Map(vec![(
        Value::Integer(Integer::from(CIP_36_61284)),
        ciborium::Value::Map(cbor_map.clone()),
    )]);

    let mut raw_61284 = Vec::new();
    ciborium::ser::into_writer(&registration_payload, &mut raw_61284)
        .map_err(|err| anyhow::anyhow!("Cannot decode cbor object from bytes, err: {err}"))?;

    Ok(raw_61284)
}

/// Extract registration from tx metadata
fn inspect_registration_from_metadata(
    metadata: &Metadatum, network: Network,
) -> anyhow::Result<Registration> {
    let metadata_bytes = metadata
        .encode_fragment()
        .map_err(|err| anyhow::anyhow!("cannot encode metadata into bytes {err}"))?;

    validate_cip36_registration(metadata_bytes.as_slice())?;

    let cbor_value = ciborium::de::from_reader::<ciborium::Value, _>(metadata_bytes.as_slice())
        .map_err(|err| anyhow::anyhow!("Cannot decode cbor object from bytes, err: {err}"))?;

    let cbor_map = cbor_value.as_map().ok_or(anyhow::anyhow!(
        "Not a valid cbor cip36 registration, should be a map"
    ))?;

    let voting_info = inspect_voting_info(cbor_map)?;
    let stake_key = inspect_stake_key(cbor_map)?;
    let rewards_address = inspect_rewards_addr(cbor_map, network)?;
    let nonce = inspect_nonce(cbor_map)?;
    let voting_purpose = inspect_voting_purpose(cbor_map)?;
    Ok(Registration {
        voting_info,
        stake_key,
        rewards_address,
        nonce,
        voting_purpose,
    })
}

/// Extract voting info
/// Voting key: simply an ED25519 public key. This is the spending credential
/// in the side chain that will receive voting power
/// from this delegation. For direct voting it's
/// necessary to have the corresponding private key
/// to cast votes in the side chain
fn inspect_voting_info(
    cbor_map: &[(ciborium::Value, ciborium::Value)],
) -> anyhow::Result<VotingInfo> {
    /// Voting info cbor key
    const VOTING_INFO_CBOR_KEY: usize = 0;
    /// Voting key cbor key
    const VOTE_KEY_CBOR_KEY: usize = 0;
    /// Weight cbor key
    const WEIGHT_CBOR_KEY: usize = 1;

    let voting_key = match cbor_map.get(VOTING_INFO_CBOR_KEY).ok_or(anyhow::anyhow!(
        "Issue with registration voting info cbor parsing"
    ))? {
        (ciborium::Value::Integer(_), ciborium::Value::Bytes(direct)) => {
            VotingInfo::Direct(PubKey(direct.clone()))
        },
        (ciborium::Value::Integer(_), ciborium::Value::Array(cbor_array)) => {
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

/// Extract stake key.
fn inspect_stake_key(cbor_map: &[(ciborium::Value, ciborium::Value)]) -> anyhow::Result<PubKey> {
    /// Stake key cbor key
    const STAKE_ADDRESS_CBOR_KEY: usize = 1;

    let stake_key = match cbor_map
        .get(STAKE_ADDRESS_CBOR_KEY)
        .ok_or(anyhow::anyhow!("Issue with stake key parsing"))?
    {
        (ciborium::Value::Integer(_two), ciborium::Value::Bytes(stake_addr)) => {
            PubKey(stake_addr.clone())
        },
        _ => return Err(anyhow::anyhow!("Missing stake key")),
    };
    Ok(stake_key)
}

/// Extract and validate rewards address
/// A Shelley payment address (see CIP-0019) discriminated for the same
/// network this transaction is submitted to, to
/// receive rewards.
fn inspect_rewards_addr(
    cbor_map: &[(ciborium::Value, ciborium::Value)], network_id: Network,
) -> anyhow::Result<RewardsAddress> {
    /// Payment address cbor key
    const PAYMENT_ADDRESS_CBOR_KEY: usize = 2;

    let (ciborium::Value::Integer(_three), ciborium::Value::Bytes(rewards_address_bytes)) =
        &cbor_map
            .get(PAYMENT_ADDRESS_CBOR_KEY)
            .ok_or(anyhow::anyhow!("Issue with rewards address parsing"))?
    else {
        return Err(anyhow::anyhow!("Invalid rewards address"));
    };

    let network_prefix = rewards_address_bytes.first().ok_or(anyhow::anyhow!(
        "Invalid rewards address, missing network prefix"
    ))?;
    if !is_valid_rewards_address(*network_prefix, network_id) {
        return Err(anyhow::anyhow!("Invalid reward address"));
    }
    Ok(RewardsAddress(rewards_address_bytes.clone()))
}

/// Extract Nonce
fn inspect_nonce(cbor_map: &[(ciborium::Value, ciborium::Value)]) -> anyhow::Result<Nonce> {
    /// Nonce cbor key
    const NONCE_CBOR_KEY: usize = 3;

    match cbor_map
        .get(NONCE_CBOR_KEY)
        .ok_or(anyhow::anyhow!("Issue with nonce parsing"))?
    {
        (ciborium::Value::Integer(_four), ciborium::Value::Integer(nonce)) => {
            Ok(Nonce(i128::from(*nonce).try_into()?))
        },
        _ => Err(anyhow::anyhow!("Missing nonce")),
    }
}

/// Extract optional voting purpose
fn inspect_voting_purpose(
    metamap: &[(ciborium::Value, ciborium::Value)],
) -> anyhow::Result<VotingPurpose> {
    /// Voting purpose cbor key
    const VOTING_PURPOSE_CBOR_KEY: usize = 4;

    // A non-negative integer that indicates the purpose of the vote.
    // This is an optional field to allow for compatibility with CIP-15
    // 4 entries inside metadata map with one optional entry for the voting
    // purpose
    match metamap.get(VOTING_PURPOSE_CBOR_KEY) {
        Some((ciborium::Value::Integer(_five), ciborium::Value::Integer(purpose))) => {
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
