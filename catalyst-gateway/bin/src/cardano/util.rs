//! Block stream parsing and filtering utils

use std::collections::HashMap;

use cryptoxide::{blake2b::Blake2b, digest::Digest};
use pallas::ledger::{
    primitives::conway::{StakeCredential, VKeyWitness},
    traverse::{Era, MultiEraAsset, MultiEraCert, MultiEraPolicyAssets},
};
use serde::Serialize;

/// Witness pub key hashed with blake2b
pub type WitnessHash = String;

/// Witness pub key in hex
pub type WitnessPubKey = String;

/// Stake credential hash from the certificate
pub type StakeCredentialHash = String;

/// Correct stake credential key in hex
pub type StakeCredentialKey = String;

/// Hash size
pub(crate) const BLAKE_2B_256_HASH_SIZE: usize = 256 / 8;

/// Helper function to generate the `blake2b_256` hash of a byte slice
pub(crate) fn hash(bytes: &[u8]) -> [u8; BLAKE_2B_256_HASH_SIZE] {
    let mut digest = [0u8; BLAKE_2B_256_HASH_SIZE];
    let mut context = Blake2b::new(BLAKE_2B_256_HASH_SIZE);
    context.input(bytes);
    context.result(&mut digest);

    digest
}

#[derive(Default, Debug, Serialize)]
/// Assets
pub struct Asset {
    /// Policy id
    pub policy_id: String,
    /// Asset name
    pub name: String,
    /// Amount in lovelace
    pub amount: u64,
}

#[derive(Default, Debug, Serialize)]
/// Parsed Assets
pub struct PolicyAsset {
    /// Policy identifier
    pub policy_hash: String,
    /// All policy assets
    pub assets: Vec<Asset>,
}

/// Extract assets
pub(crate) fn parse_policy_assets(assets: &[MultiEraPolicyAssets<'_>]) -> Vec<PolicyAsset> {
    assets
        .iter()
        .map(|asset| {
            PolicyAsset {
                policy_hash: asset.policy().to_string(),
                assets: parse_child_assets(&asset.assets()),
            }
        })
        .collect()
}

/// Parse child assets
fn parse_child_assets(assets: &[MultiEraAsset]) -> Vec<Asset> {
    assets
        .iter()
        .filter_map(|asset| {
            match asset {
                MultiEraAsset::AlonzoCompatibleOutput(id, name, amount) => {
                    Some(Asset {
                        policy_id: id.to_string(),
                        name: name.to_string(),
                        amount: *amount,
                    })
                },
                MultiEraAsset::AlonzoCompatibleMint(id, name, amount) => {
                    let amount = u64::try_from(*amount).ok()?;
                    Some(Asset {
                        policy_id: id.to_string(),
                        name: name.to_string(),
                        amount,
                    })
                },
                _ => Some(Asset::default()),
            }
        })
        .collect()
}

/// Eras before staking should be ignored
pub fn valid_era(era: Era) -> bool {
    !matches!(era, Era::Byron)
}

/// Extract stake credentials from certificates. Stake credentials are 28 byte blake2b
/// hashes.
#[allow(dead_code)]
pub fn extract_stake_credentials_from_certs(
    certs: &[MultiEraCert<'_>],
) -> Vec<StakeCredentialHash> {
    let mut stake_credentials = Vec::new();

    for cert in certs {
        if let Some(cert) = cert.as_alonzo() {
            match cert {
                pallas::ledger::primitives::alonzo::Certificate::StakeDelegation(
                    stake_credential,
                    _,
                ) => {
                    match stake_credential {
                        StakeCredential::AddrKeyhash(stake_credential) => {
                            stake_credentials.push(hex::encode(stake_credential.as_slice()));
                        },
                        StakeCredential::Scripthash(_) => (),
                    }
                },
                _ => continue,
            }
        }
    }

    stake_credentials
}

/// Get a Blake2b-224 (28 byte) hash of some bytes
pub(crate) fn blake2b_224(value: &[u8]) -> [u8; 28] {
    let mut digest = [0u8; 28];
    let mut context = Blake2b::new(28);
    context.input(value);
    context.result(&mut digest);
    digest
}

/// A map of hashed witnesses.
pub(crate) type HashedWitnesses = HashMap<[u8; 28], Vec<u8>>;

/// Extract witness pub keys and pair with blake2b hash of the pub key.
/// This converts raw Addresses to their hashes as used on Cardano (Blake2b-224).
/// And allows them to be easily cross referenced.
pub(crate) fn extract_hashed_witnesses(witnesses: &[VKeyWitness]) -> HashedWitnesses {
    let mut hashed_witnesses = HashMap::new();
    for witness in witnesses {
        let pub_key = witness.vkey.to_vec();
        let hash = blake2b_224(&pub_key);

        hashed_witnesses.insert(hash, pub_key);
    }

    hashed_witnesses
}

/// Match hashed witness pub keys with hashed stake credentials from the TX certificates
/// to identify the correct stake credential key.
#[allow(dead_code)]
pub fn find_matching_stake_credential(
    witnesses: &[(WitnessPubKey, WitnessHash)], stake_credentials: &[String],
) -> anyhow::Result<(StakeCredentialKey, StakeCredentialHash)> {
    stake_credentials
        .iter()
        .zip(witnesses.iter())
        .find_map(|(stake_credential, (pub_key, pub_key_hash))| {
            if stake_credential == pub_key_hash {
                Some((pub_key.clone(), pub_key_hash.clone()))
            } else {
                None
            }
        })
        .ok_or(anyhow::anyhow!(
            "No stake credential from the certificates matches any of the witness pub keys"
        ))
}
