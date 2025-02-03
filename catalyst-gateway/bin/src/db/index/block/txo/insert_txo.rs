//! Insert TXO Indexed Data Queries.
//!
//! Note, there are multiple ways TXO Data is indexed and they all happen in here.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbTransactionHash, DbTxnIndex},
    },
    settings::cassandra_db,
};

/// TXO by Stake Address Indexing query
const INSERT_TXO_QUERY: &str = include_str!("./cql/insert_txo.cql");

/// Insert TXO Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow, Debug)]
pub(crate) struct Params {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: DbSlot,
    /// Transaction Offset inside the block.
    txn: DbTxnIndex,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Actual full TXO Address
    address: String,
    /// Actual TXO Value in lovelace
    value: num_bigint::BigInt,
    /// Transactions hash.
    txn_hash: DbTransactionHash,
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        stake_address: &[u8], slot_no: DbSlot, txn: DbTxnIndex, txo: i16, address: &str,
        value: u64, txn_hash: DbTransactionHash,
    ) -> Self {
        Self {
            stake_address: stake_address.to_vec(),
            slot_no,
            txn,
            txo,
            address: address.to_string(),
            value: value.into(),
            txn_hash,
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
