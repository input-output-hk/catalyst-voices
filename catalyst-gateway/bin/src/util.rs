//! Block stream parsing and filtering utils

use std::error::Error;

use pallas::ledger::{
    primitives::conway::{StakeCredential, VKeyWitness},
    traverse::{Era, MultiEraAsset, MultiEraCert, MultiEraPolicyAssets},
};

use cryptoxide::{blake2b::Blake2b, digest::Digest};
use ed25519_dalek::VerifyingKey;

use serde::Serialize;

/// Witness pub key hashed with blake2b
pub type WitnessHash = String;

/// Witness pub key in hex
pub type WitnessPubKey = String;

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
pub fn parse_policy_assets(assets: &[MultiEraPolicyAssets<'_>]) -> Vec<PolicyAsset> {
    assets
        .iter()
        .map(|asset| PolicyAsset {
            policy_hash: asset.policy().to_string(),
            assets: parse_child_assets(&asset.assets()),
        })
        .collect()
}

/// Parse child assets
pub fn parse_child_assets(assets: &[MultiEraAsset]) -> Vec<Asset> {
    assets
        .iter()
        .filter_map(|asset| match asset {
            MultiEraAsset::AlonzoCompatibleOutput(id, name, amount) => Some(Asset {
                policy_id: id.to_string(),
                name: name.to_string(),
                amount: *amount,
            }),
            MultiEraAsset::AlonzoCompatibleMint(id, name, amount) => {
                let amount = u64::try_from(*amount).ok()?;
                Some(Asset {
                    policy_id: id.to_string(),
                    name: name.to_string(),
                    amount,
                })
            },
            _ => Some(Asset::default()),
        })
        .collect()
}

/// Eras before staking should be ignored
pub fn valid_era(era: Era) -> bool {
    matches!(
        era,
        Era::Shelley | Era::Allegra | Era::Mary | Era::Alonzo | Era::Babbage | Era::Conway
    )
}

/// Extract hashed keys
pub fn extract_hashed_keys(certs: Vec<MultiEraCert<'_>>) -> Vec<String> {
    let mut keys = Vec::new();

    for c in certs.iter() {
        if let Some(cert) = c.as_alonzo() {
            match cert {
                pallas::ledger::primitives::alonzo::Certificate::StakeDelegation(
                    stake_credential,
                    _,
                ) => match stake_credential {
                    StakeCredential::AddrKeyhash(stake_credential) => {
                        keys.push(hex::encode(stake_credential.as_slice()))
                    },
                    StakeCredential::Scripthash(_) => (),
                },
                _ => continue,
            }
        }
    }

    keys
}

// Extract witness pub keys and hash them with blake2b in order to find a stake credential match
pub fn extract_hashed_witnesses(
    witnesses: &[VKeyWitness],
) -> Result<Vec<(WitnessPubKey, WitnessHash)>, Box<dyn Error>> {
    let mut hashed_witnesses = Vec::new();
    for witness in witnesses {
        let arr: [u8; 32] = witness.vkey.as_slice().try_into()?;

        let public_key = VerifyingKey::from_bytes(&arr)?;

        let bytes = public_key.as_bytes();
        let pub_key_hex = hex::encode(bytes);

        let mut digest = [0u8; 28];
        let mut context = Blake2b::new(28);
        context.input(bytes);
        context.result(&mut digest);
        hashed_witnesses.push((pub_key_hex, hex::encode(digest)))
    }

    Ok(hashed_witnesses)
}

/// match certificate keys with witnesses
pub fn match_certificate_with_witness(
    witnesses: Vec<(WitnessPubKey, WitnessHash)>, certs: Vec<String>,
) -> Result<String, Box<dyn Error>> {
    let matched_pub_key =
        certs
            .iter()
            .zip(witnesses.iter())
            .find_map(|(cert, (pub_key, pub_key_hash))| {
                if cert == pub_key_hash {
                    Some(pub_key)
                } else {
                    None
                }
            });

    match matched_pub_key {
        Some(pub_key) => Ok(pub_key.to_string()),
        None => Err("no matches".into()),
    }
}
