//! Index a block

use std::sync::Arc;

use cardano_chain_follower::MultiEraBlock;
use scylla::SerializeRow;
use tokio::join;
use tracing::{debug, error, warn};

use super::session::session;

/// TXO by Stake Address Indexing query
const INSERT_TXO_QUERY: &str = include_str!("./queries/insert_txo.cql");
/// TXO Asset by Stake Address Indexing Query
const INSERT_TXO_ASSET_QUERY: &str = include_str!("./queries/insert_txo_asset.cql");
/// TXI by Txn hash Index
const INSERT_TXI_QUERY: &str = include_str!("./queries/insert_txi.cql");
/// This is used to indicate that there is no stake address, and still meet the
/// requirement for the index primary key to be non empty.
const NO_STAKE_ADDRESS: &[u8] = &[0; 1];

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
/// If we want to index, but can not determine a stake key hash, then return a Vec with a
/// single 0 byte.    This is because the index DB needs data in the primary key, so we
/// use a single byte of 0 to indicate    that there is no stake address, and still have a
/// primary key on the table. Otherwise return the stake key hash as a vec of 28 bytes.
fn extract_stake_address(
    txo: &pallas::ledger::traverse::MultiEraOutput,
) -> Option<(Vec<u8>, String)> {
    let stake_address = match txo.address() {
        Ok(address) => {
            match address {
                // Byron addresses do not have stake addresses and are not supported.
                pallas::ledger::addresses::Address::Byron(_) => {
                    return None;
                },
                pallas::ledger::addresses::Address::Shelley(address) => {
                    let address_string = match address.to_bech32() {
                        Ok(address) => address,
                        Err(error) => {
                            error!(error=%error,"Error converting to bech32: skipping.");
                            return None;
                        },
                    };

                    match address.delegation() {
                        pallas::ledger::addresses::ShelleyDelegationPart::Script(hash)
                        | pallas::ledger::addresses::ShelleyDelegationPart::Key(hash) => {
                            (hash.to_vec(), address_string)
                        },
                        pallas::ledger::addresses::ShelleyDelegationPart::Pointer(_) => {
                            warn!("Pointer Stake address detected, not supported. Treat as if there is no stake address.");
                            (NO_STAKE_ADDRESS.to_vec(), address_string)
                        },
                        pallas::ledger::addresses::ShelleyDelegationPart::Null => {
                            (NO_STAKE_ADDRESS.to_vec(), address_string)
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

/// Index the transaction Inputs.
fn index_txi(
    session: &Arc<scylla::Session>, txi_query: &scylla::prepared_statement::PreparedStatement,
    txs: &pallas::ledger::traverse::MultiEraTx<'_>, slot_no: u64,
) -> Vec<tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>>
{
    let mut query_handles: Vec<
        tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>,
    > = Vec::new();

    // Index the TXI's.
    for txi in txs.inputs() {
        let txn_hash = txi.hash().to_vec();
        let txo: i16 = txi.index().try_into().unwrap_or(i16::MAX);

        let nested_txi_query = txi_query.clone();
        let nested_session = session.clone();
        query_handles.push(tokio::spawn(async move {
            nested_session
                .execute(&nested_txi_query, TxiInsertParams {
                    txn_hash,
                    txo,
                    slot_no: slot_no.into(),
                })
                .await
        }));
    }

    query_handles
}

/// Index the transaction Outputs.
fn index_txo(
    session: &Arc<scylla::Session>, txo_query: &scylla::prepared_statement::PreparedStatement,
    txo_asset_query: &scylla::prepared_statement::PreparedStatement,
    txs: &pallas::ledger::traverse::MultiEraTx<'_>, slot_no: u64, txn_hash: &[u8], txn_index: i16,
) -> Vec<tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>>
{
    let mut query_handles: Vec<
        tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>,
    > = Vec::new();

    for (txo_index, txo) in txs.outputs().iter().enumerate() {
        let Some((stake_address, address)) = extract_stake_address(txo) else {
            continue;
        };

        let value = txo.lovelace_amount();

        let nested_txo_query = txo_query.clone();
        let nested_session = session.clone();
        let nested_txn_hash = txn_hash.to_vec();
        let nested_stake_address = stake_address.clone();
        query_handles.push(tokio::spawn(async move {
            nested_session
                .execute(&nested_txo_query, TxoInsertParams {
                    stake_address: nested_stake_address,
                    slot_no: slot_no.into(),
                    txn: txn_index,
                    txo: usize_to_i16(txo_index),
                    address,
                    value: value.into(),
                    txn_hash: nested_txn_hash,
                })
                .await
        }));

        for asset in txo.non_ada_assets() {
            let policy_id = asset.policy().to_vec();
            for policy_asset in asset.assets() {
                if policy_asset.is_output() {
                    let policy_name = policy_asset.to_ascii_name().unwrap_or_default();
                    let value = policy_asset.any_coin();

                    let nested_txo_asset_query = txo_asset_query.clone();
                    let nested_session = session.clone();
                    let nested_txn_hash = txn_hash.to_vec();
                    let nested_stake_address = stake_address.clone();
                    let nested_policy_id = policy_id.clone();
                    query_handles.push(tokio::spawn(async move {
                        nested_session
                            .execute(&nested_txo_asset_query, TxoAssetInsertParams {
                                stake_address: nested_stake_address,
                                slot_no: slot_no.into(),
                                txn: txn_index,
                                txo: usize_to_i16(txo_index),
                                policy_id: nested_policy_id,
                                policy_name,
                                value: value.into(),
                                txn_hash: nested_txn_hash,
                            })
                            .await
                    }));
                } else {
                    error!("Minting MultiAsset in TXO.");
                }
            }
        }
    }
    query_handles
}

/// Add all data needed from the block into the indexes.
#[allow(clippy::similar_names)]
pub(crate) async fn index_block(block: &MultiEraBlock) -> anyhow::Result<()> {
    // Get the session.  This should never fail.
    let Some(session) = session(block.immutable()) else {
        anyhow::bail!("Failed to get Index DB Session.  Can not index block.");
    };

    // As our indexing operations span multiple partitions, they can not be batched.
    // So use tokio threads to allow multiple writes to be dispatched simultaneously.
    let mut query_handles: Vec<
        tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>,
    > = Vec::new();

    // Pre-prepare our queries.
    let (txo_query, txo_asset_query, txi_query) = join!(
        session.prepare(INSERT_TXO_QUERY),
        session.prepare(INSERT_TXO_ASSET_QUERY),
        session.prepare(INSERT_TXI_QUERY),
    );

    if let Err(ref error) = txo_query {
        error!(error=%error,"Failed to prepare Insert TXO Query.");
    };
    if let Err(ref error) = txo_asset_query {
        error!(error=%error,"Failed to prepare Insert TXO Asset Query.");
    };
    if let Err(ref error) = txi_query {
        error!(error=%error,"Failed to prepare Insert TXI Query.");
    };

    let mut txo_query = txo_query?;
    let mut txo_asset_query = txo_asset_query?;
    let mut txi_query = txi_query?;

    // We just want to write as fast as possible, consistency at this stage isn't required.
    txo_query.set_consistency(scylla::statement::Consistency::Any);
    txo_asset_query.set_consistency(scylla::statement::Consistency::Any);
    txi_query.set_consistency(scylla::statement::Consistency::Any);

    // These operations are idempotent, because they are always the same data.
    txo_query.set_is_idempotent(true);
    txo_asset_query.set_is_idempotent(true);
    txi_query.set_is_idempotent(true);

    let block_data = block.decode();
    let slot_no = block_data.slot();

    for (txn_index, txs) in block_data.txs().iter().enumerate() {
        let txn_hash = txs.hash().to_vec();

        // Index the TXI's.
        query_handles.append(&mut index_txi(&session, &txi_query, txs, slot_no));

        // TODO: Index minting.
        // let mint = txs.mints().iter() {};

        // TODO: Index Metadata.

        // TODO: Index Stake address hash to stake address reverse lookups.

        // Index the TXO's.
        query_handles.append(&mut index_txo(
            &session,
            &txo_query,
            &txo_asset_query,
            txs,
            slot_no,
            &txn_hash,
            usize_to_i16(txn_index),
        ));
    }

    // Wait for operations to complete, and display any errors
    for handle in query_handles {
        match handle.await {
            Ok(join_res) => {
                match join_res {
                    Ok(res) => debug!(res=?res,"Query OK"),
                    Err(error) => error!(error=%error,"Query Failed"),
                }
            },
            Err(error) => error!(error=%error,"Query Join Failed"),
        }
    }

    Ok(())
}
