//! Block stream parsing and filtering utils
use pallas::ledger::{
    primitives::conway::StakeCredential,
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
#[allow(dead_code)]
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
#[allow(dead_code)]
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
#[allow(dead_code)]
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
                        StakeCredential::ScriptHash(_) => (),
                    }
                },
                _ => continue,
            }
        }
    }

    stake_credentials
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
