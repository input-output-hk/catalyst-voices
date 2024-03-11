//! Block stream parsing and filtering utils

use pallas::ledger::traverse::{Era, MultiEraAsset, MultiEraPolicyAssets};
use serde::Serialize;

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

/// Eras before staking should be ignored
pub fn valid_era(era: Era) -> bool {
    matches!(
        era,
        Era::Shelley | Era::Allegra | Era::Mary | Era::Alonzo | Era::Babbage | Era::Conway
    )
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
