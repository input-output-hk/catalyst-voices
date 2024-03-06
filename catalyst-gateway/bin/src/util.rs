//! Block stream parsing and filtering utils

use pallas::ledger::traverse::{Era, MultiEraAsset, MultiEraPolicyAssets};
use serde::Serialize;

#[derive(Default, Debug, Serialize)]
/// Assets
pub struct Asset {
    pub policy_id: String,
    pub asset_name: String,
    pub amount: u64,
}

#[derive(Default, Debug, Serialize)]
/// Parsed Assets
pub struct PolicyAsset {
    pub policy_hash: String,
    pub assets: Vec<Asset>,
}

/// Eras before staking should be ignored
pub fn valid_era(era: Era) -> bool {
    match era {
        Era::Shelley => true,
        Era::Allegra => true,
        Era::Mary => true,
        Era::Alonzo => true,
        Era::Babbage => true,
        Era::Conway => true,
        _ => false,
    }
}

/// Extract assets
pub fn parse_policy_assets(assets: &Vec<MultiEraPolicyAssets<'_>>) -> Vec<PolicyAsset> {
    assets
        .iter()
        .map(|asset| {
            PolicyAsset {
                policy_hash: asset.policy().to_string(),
                assets: parse_child_assets(asset.assets()),
            }
        })
        .collect()
}

/// Parse child assets
pub fn parse_child_assets(assets: Vec<MultiEraAsset>) -> Vec<Asset> {
    assets
        .iter()
        .map(|asset| {
            match asset {
                MultiEraAsset::AlonzoCompatibleOutput(id, name, amount) => {
                    Asset {
                        policy_id: id.to_string(),
                        asset_name: name.to_string(),
                        amount: *amount,
                    }
                },
                MultiEraAsset::AlonzoCompatibleMint(id, name, amount) => {
                    Asset {
                        policy_id: id.to_string(),
                        asset_name: name.to_string(),
                        amount: *amount as u64,
                    }
                },
                _ => Asset::default(),
            }
        })
        .collect()
}
