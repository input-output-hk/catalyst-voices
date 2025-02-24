//! Insert TXO Indexed Data Queries.
//!
//! Note, there are multiple ways TXO Data is indexed and they all happen in here.

use std::sync::Arc;

use cardano_blockchain_types::{Slot, StakeAddress, TransactionId, TxnIndex, TxnOutputOffset};
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbStakeAddress, DbTransactionId, DbTxnIndex, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

/// TXO by Stake Address Indexing query
const INSERT_TXO_QUERY: &str = include_str!("./cql/insert_txo.cql");

/// Insert TXO Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow, Debug)]
pub(crate) struct Params {
    /// Stake Address - Binary 29 bytes.
    stake_address: DbStakeAddress,
    /// Block Slot Number
    slot_no: DbSlot,
    /// Transaction Offset inside the block.
    txn_index: DbTxnIndex,
    /// Transaction Output Offset inside the transaction.
    txo: DbTxnOutputOffset,
    /// Actual full TXO Address
    address: String,
    /// Actual TXO Value in lovelace
    value: num_bigint::BigInt,
    /// Transactions hash.
    txn_hash: DbTransactionId,
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        stake_address: StakeAddress, slot_no: Slot, txn_index: TxnIndex, txo: TxnOutputOffset,
        address: &str, value: u64, txn_hash: TransactionId,
    ) -> Self {
        Self {
            stake_address: stake_address.into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            txo: txo.into(),
            address: address.to_string(),
            value: value.into(),
            txn_hash: txn_hash.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_TXO_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(|error| error!(error=%error,"Failed to prepare Insert TXO Query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_TXO_QUERY}"))
    }
}
