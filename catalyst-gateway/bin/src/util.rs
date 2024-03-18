//! Block stream parsing and filtering utils

use std::error::Error;

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
        .map(|asset| {
            PolicyAsset {
                policy_hash: asset.policy().to_string(),
                assets: parse_child_assets(&asset.assets()),
            }
        })
        .collect()
}

/// Parse child assets
pub fn parse_child_assets(assets: &[MultiEraAsset]) -> Vec<Asset> {
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
    matches!(
        era,
        Era::Shelley | Era::Allegra | Era::Mary | Era::Alonzo | Era::Babbage | Era::Conway
    )
}

/// Extract stake credentials from certificates. Stake credentials are 28 byte blake2b
/// hashes.
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

/// Extract witness pub keys and pair with blake2b hash of the pub key.
/// Hashes are generally 32-byte long on Cardano (or 256 bits),
/// except for credentials (i.e. keys or scripts) which are 28-byte long (or 224 bits)
pub fn extract_hashed_witnesses(
    witnesses: &[VKeyWitness],
) -> Result<Vec<(WitnessPubKey, WitnessHash)>, Box<dyn Error>> {
    let mut hashed_witnesses = Vec::new();
    for witness in witnesses {
        let pub_key_bytes: [u8; 32] = witness.vkey.as_slice().try_into()?;

        let pub_key_hex = hex::encode(pub_key_bytes);

        let mut digest = [0u8; 28];
        let mut context = Blake2b::new(28);
        context.input(&pub_key_bytes);
        context.result(&mut digest);
        hashed_witnesses.push((pub_key_hex, hex::encode(digest)));
    }

    Ok(hashed_witnesses)
}

/// Match hashed witness pub keys with hashed stake credentials from the TX certificates
/// to identify the correct stake credential key.
pub fn find_matching_stake_credential(
    witnesses: &[(WitnessPubKey, WitnessHash)], stake_credentials: &[String],
) -> Result<(StakeCredentialKey, StakeCredentialHash), Box<dyn Error>> {
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
        .ok_or(
            "No stake credential from the certificates matches any of the witness pub keys".into(),
        )
}
