//! Index a block

use cardano_chain_follower::MultiEraBlock;
use scylla::{batch::Batch, SerializeRow};
use tokio::try_join;
use tracing::{error, warn};

use super::session::session;

/// TXO by Stake Address Indexing query
const INSERT_TXO_QUERY: &str = include_str!("./queries/insert_txo.cql");
/// TXO Asset by Stake Address Indexing Query
const INSERT_TXO_ASSET_QUERY: &str = include_str!("./queries/insert_txo_asset.cql");
/// TXI by Txn hash Index
const INSERT_TXI_QUERY: &str = include_str!("./queries/insert_txi.cql");

/// Insert TXO Query Parameters
#[derive(SerializeRow)]
struct TxoInsertParams {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Actual full TXO Address
    address: String,
    /// Actual TXO Value in lovelace
    value: num_bigint::BigInt,
    /// Transactions hash.
    txn_hash: Vec<u8>,
}

/// Insert TXO Asset Query Parameters
#[derive(SerializeRow)]
struct TxoAssetInsertParams {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Policy hash of the asset
    policy_id: Vec<u8>,
    /// Policy name of the asset
    policy_name: String,
    /// Value of the asset
    value: num_bigint::BigInt,
    /// Transactions hash.
    txn_hash: Vec<u8>,
}

/// Insert TXI Query Parameters
#[derive(SerializeRow)]
struct TxiInsertParams {
    /// Spent Transactions Hash
    txn_hash: Vec<u8>,
    /// TXO Index spent.
    txo: i16,
    /// Block Slot Number when spend occurred.
    slot_no: num_bigint::BigInt,
}

/// Extracts a stake address from a TXO if possible.
/// Returns None if it is not possible.
/// If we want to index, but can not determine a stake key hash, then return an empty Vec.
/// Otherwise return the stake key hash as a vec of 28 bytes.
fn extract_stake_address(
    txo: &pallas::ledger::traverse::MultiEraOutput,
) -> Option<(Vec<u8>, String)> {
    let stake_address = match txo.address() {
        Ok(address) => {
            let address_string = match address.to_bech32() {
                Ok(address) => address,
                Err(error) => {
                    error!(error=%error,"Error converting to bech32: skipping.");
                    return None;
                },
            };

            match address {
                // Byron addresses do not have stake addresses.
                pallas::ledger::addresses::Address::Byron(_) => (Vec::<u8>::new(), address_string),
                pallas::ledger::addresses::Address::Shelley(address) => {
                    match address.delegation() {
                        pallas::ledger::addresses::ShelleyDelegationPart::Key(hash) => {
                            (hash.to_vec(), address_string)
                        },
                        pallas::ledger::addresses::ShelleyDelegationPart::Script(_) => {
                            warn!("Script Stake address detected, not supported. Not indexing.");
                            (Vec::<u8>::new(), address_string)
                        },
                        pallas::ledger::addresses::ShelleyDelegationPart::Pointer(_) => {
                            warn!("Pointer Stake address detected, not supported. Not indexing.");
                            (Vec::<u8>::new(), address_string)
                        },
                        pallas::ledger::addresses::ShelleyDelegationPart::Null => {
                            (Vec::<u8>::new(), address_string)
                        },
                    }
                },
                pallas::ledger::addresses::Address::Stake(_) => {
                    // This should NOT appear in a TXO, so report if it does. But don't index it as
                    // a stake address.
                    warn!("Unexpected Stake address found in TXO. Refusing to index.");
                    return None;
                },
            }
        },
        Err(error) => {
            // This should not ever happen.
            error!(error=%error, "Failed to get Address from TXO. Skipping TXO.");
            return None;
        },
    };

    Some(stake_address)
}

/// Convert a usize to an i16 and saturate at `i16::MAX`
fn usize_to_i16(value: usize) -> i16 {
    value.try_into().unwrap_or(i16::MAX)
}

/// Add all data needed from the block into the indexes.
#[allow(clippy::similar_names)]
pub(crate) async fn index_block(block: &MultiEraBlock) -> anyhow::Result<()> {
    // Get the session.  This should never fail.
    let Some(session) = session(block.immutable()) else {
        anyhow::bail!("Failed to get Index DB Session.  Can not index block.");
    };

    // Create a batch statement
    let mut txo_batch: Batch = Batch::default();
    let mut txo_values = Vec::<TxoInsertParams>::new();

    let mut txo_asset_batch: Batch = Batch::default();
    let mut txo_asset_values = Vec::<TxoAssetInsertParams>::new();

    let mut txi_batch: Batch = Batch::default();
    let mut txi_values = Vec::<TxiInsertParams>::new();

    let block_data = block.decode();
    let slot_no = block_data.slot();

    for (txn_index, txs) in block_data.txs().iter().enumerate() {
        let txn_hash = txs.hash().to_vec();

        // Index the TXI's.
        for txi in txs.inputs() {
            let txn_hash = txi.hash().to_vec();
            let txo: i16 = txi.index().try_into().unwrap_or(i16::MAX);

            txi_batch.append_statement(INSERT_TXI_QUERY);
            txi_values.push(TxiInsertParams {
                txn_hash,
                txo,
                slot_no: slot_no.into(),
            });
        }

        // TODO: Index minting.
        // let mint = txs.mints().iter() {};

        // TODO: Index Metadata.

        // TODO: Index Stake address hash to stake address reverse lookups.

        // Index the TXO's.
        for (txo_index, txo) in txs.outputs().iter().enumerate() {
            let Some((stake_address, address)) = extract_stake_address(txo) else {
                continue;
            };

            let value = txo.lovelace_amount();

            txo_batch.append_statement(INSERT_TXO_QUERY);
            txo_values.push(TxoInsertParams {
                stake_address: stake_address.clone(),
                slot_no: slot_no.into(),
                txn: usize_to_i16(txn_index),
                txo: usize_to_i16(txo_index),
                address,
                value: value.into(),
                txn_hash: txn_hash.clone(),
            });

            for asset in txo.non_ada_assets() {
                let policy_id = asset.policy().to_vec();
                for policy_asset in asset.assets() {
                    if policy_asset.is_output() {
                        let policy_name = policy_asset.to_ascii_name().unwrap_or_default();
                        let value = policy_asset.any_coin();

                        txo_asset_batch.append_statement(INSERT_TXO_ASSET_QUERY);
                        txo_asset_values.push(TxoAssetInsertParams {
                            stake_address: stake_address.clone(),
                            slot_no: slot_no.into(),
                            txn: usize_to_i16(txn_index),
                            txo: usize_to_i16(txo_index),
                            policy_id: policy_id.clone(),
                            policy_name,
                            value: value.into(),
                            txn_hash: txn_hash.clone(),
                        });
                    } else {
                        error!("Minting MultiAsset in TXO.");
                    }
                }
            }
        }
    }

    // Prepare all statements in the batch at once
    let (prepared_txo_batch, prepared_txo_asset_batch, prepared_txi_batch) = try_join!(
        session.prepare_batch(&txo_batch),
        session.prepare_batch(&txo_asset_batch),
        session.prepare_batch(&txi_batch),
    )?;

    // Run the prepared batch
    let _res = try_join!(
        session.batch(&prepared_txo_batch, txo_values),
        session.batch(&prepared_txo_asset_batch, txo_asset_values),
        session.batch(&prepared_txi_batch, txi_values),
    )?;

    Ok(())
}
