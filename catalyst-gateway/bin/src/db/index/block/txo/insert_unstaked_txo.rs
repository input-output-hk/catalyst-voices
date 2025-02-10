//! Insert Unstaked TXOs into the DB.
use std::sync::Arc;

use cardano_blockchain_types::{Slot, TransactionHash, TxnIndex, TxnOutputOffset};
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbTransactionHash, DbTxnIndex, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

/// Unstaked TXO by Stake Address Indexing query
const INSERT_UNSTAKED_TXO_QUERY: &str = include_str!("./cql/insert_unstaked_txo.cql");

/// Insert TXO Unstaked Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow, Debug)]
pub(crate) struct Params {
    /// Transactions hash.
    txn_hash: DbTransactionHash,
    /// Transaction Output Offset inside the transaction.
    txo: DbTxnOutputOffset,
    /// Block Slot Number
    slot_no: DbSlot,
    /// Transaction Offset inside the block.
    txn: DbTxnIndex,
    /// Actual full TXO Address
    address: String,
    /// Actual TXO Value in lovelace
    value: num_bigint::BigInt,
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        txn_hash: TransactionHash, txo: TxnOutputOffset, slot_no: Slot, txn: TxnIndex,
        address: &str, value: u64,
    ) -> Self {
        Self {
            txn_hash: txn_hash.into(),
            txo: txo.into(),
            slot_no: slot_no.into(),
            txn: txn.into(),
            address: address.to_string(),
            value: value.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_UNSTAKED_TXO_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(|error| error!(error=%error,"Failed to prepare Unstaked Insert TXO Query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_UNSTAKED_TXO_QUERY}"))
    }
}
