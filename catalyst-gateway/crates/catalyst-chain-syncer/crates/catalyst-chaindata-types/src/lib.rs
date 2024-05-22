pub mod serde_size;

use std::str::FromStr;

use chrono::{DateTime, Utc};
use pallas_traverse::{
    wellknown::GenesisValues, MultiEraAsset, MultiEraBlock, MultiEraPolicyAssets, MultiEraTx,
};
use serde::Serialize;

use crate::serde_size::serde_size;

lazy_static::lazy_static! {
    static ref MAINNET_GENESIS_VALUES: GenesisValues = GenesisValues::mainnet();
    static ref PREPROD_GENESIS_VALUES: GenesisValues = GenesisValues::preprod();
}

#[derive(Debug, Clone, Copy)]
pub struct CardanoBlock {
    pub block_no: u64,
    pub slot_no: u64,
    pub epoch_no: u64,
    pub network: Network,
    pub block_time: DateTime<Utc>,
    pub block_hash: [u8; 32],
    pub previous_hash: Option<[u8; 32]>,
}

impl CardanoBlock {
    pub fn from_block(block: &MultiEraBlock, network: Network) -> anyhow::Result<Self> {
        Ok(Self {
            block_no: block.number(),
            slot_no: block.slot(),
            epoch_no: block.epoch(network.genesis_values()).0,
            network,
            block_time: DateTime::from_timestamp(
                block.wallclock(network.genesis_values()) as i64,
                0,
            )
            .ok_or_else(|| anyhow::anyhow!("Failed to parse DateTime from timestamp"))?,
            block_hash: *block.hash(),
            previous_hash: block.header().previous_hash().as_ref().map(|h| **h),
        })
    }
}

pub struct CardanoTransaction {
    pub hash: [u8; 32],
    pub block_no: u64,
    pub network: Network,
}

impl CardanoTransaction {
    pub fn many_from_block(block: &MultiEraBlock, network: Network) -> anyhow::Result<Vec<Self>> {
        let data = block
            .txs()
            .into_iter()
            .map(|tx| Self {
                hash: *tx.hash(),
                block_no: block.number(),
                network,
            })
            .collect();

        Ok(data)
    }
}

pub struct CardanoTxo {
    pub transaction_hash: [u8; 32],
    pub index: u32,
    pub value: u64,
    pub assets: serde_json::Value,
    pub assets_size_estimate: usize,
    pub stake_credential: Option<[u8; 28]>,
}

impl CardanoTxo {
    pub fn from_transactions(txs: &[MultiEraTx]) -> anyhow::Result<Vec<Self>> {
        let data = txs
            .iter()
            .flat_map(|tx| {
                tx.outputs().into_iter().zip(0..).map(|(tx_output, index)| {
                    let address = tx_output.address()?;

                    let stake_credential = match address {
                        pallas_addresses::Address::Byron(_) => None,
                        pallas_addresses::Address::Shelley(address) => address.try_into().ok(),
                        pallas_addresses::Address::Stake(stake_address) => Some(stake_address),
                    };

                    // let parsed_assets = parse_policy_assets(&tx_output.non_ada_assets());
                    // let assets_size_estimate = serde_size(&parsed_assets)?;
                    // let assets = serde_json::to_value(&parsed_assets)?;
                    let assets_size_estimate = 0;
                    let assets = serde_json::Value::Null;

                    Ok(Self {
                        transaction_hash: *tx.hash(),
                        index,
                        value: tx_output.lovelace_amount(),
                        assets,
                        assets_size_estimate,
                        stake_credential: stake_credential.map(|a| **a.payload().as_hash()),
                    })
                })
            })
            .collect::<anyhow::Result<Vec<_>>>()?;

        Ok(data)
    }
}

pub struct CardanoSpentTxo {
    pub from_transaction_hash: [u8; 32],
    pub index: u32,
    pub to_transaction_hash: [u8; 32],
}

impl CardanoSpentTxo {
    pub fn from_transactions(txs: &[MultiEraTx]) -> anyhow::Result<Vec<Self>> {
        let data = txs
            .iter()
            .flat_map(|tx| {
                tx.inputs().into_iter().map(|tx_input| Self {
                    from_transaction_hash: **tx_input.output_ref().hash(),
                    index: tx_input.output_ref().index() as u32,
                    to_transaction_hash: *tx.hash(),
                })
            })
            .collect();

        Ok(data)
    }
}

#[derive(Debug, Serialize)]
struct Asset {
    pub policy_id: String,
    pub name: String,
    pub amount: u64,
}

#[derive(Debug, Serialize)]
struct PolicyAsset {
    pub policy_hash: String,
    pub assets: Vec<Asset>,
}

fn parse_policy_assets(assets: &[MultiEraPolicyAssets<'_>]) -> Vec<PolicyAsset> {
    assets
        .iter()
        .map(|asset| PolicyAsset {
            policy_hash: asset.policy().to_string(),
            assets: parse_child_assets(&asset.assets()),
        })
        .collect()
}

fn parse_child_assets(assets: &[MultiEraAsset]) -> Vec<Asset> {
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
            }
            _ => None,
        })
        .collect()
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Network {
    Mainnet,
    Preprod,
}

impl Network {
    pub fn id(&self) -> u16 {
        match self {
            Network::Mainnet => 0,
            Network::Preprod => 1,
        }
    }

    pub fn genesis_values(&self) -> &'static GenesisValues {
        match self {
            Network::Mainnet => &MAINNET_GENESIS_VALUES,
            Network::Preprod => &PREPROD_GENESIS_VALUES,
        }
    }
}

impl FromStr for Network {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "mainnet" => Ok(Self::Mainnet),
            "preprod" => Ok(Self::Preprod),
            _ => Err(anyhow::format_err!("Unknown network: '{}'", s)),
        }
    }
}
