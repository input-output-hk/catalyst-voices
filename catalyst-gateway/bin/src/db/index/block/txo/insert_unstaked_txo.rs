//! Insert Unstaked TXOs into the DB.
use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::cassandra_db,
};

/// Unstaked TXO by Stake Address Indexing query
const INSERT_UNSTAKED_TXO_QUERY: &str = include_str!("./cql/insert_unstaked_txo.cql");

/// Insert TXO Unstaked Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow, Debug)]
pub(crate) struct Params {
    /// Transactions hash.
    txn_hash: Vec<u8>,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Actual full TXO Address
    address: String,
    /// Actual TXO Value in lovelace
    value: num_bigint::BigInt,
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        txn_hash: &[u8], txo: i16, slot_no: u64, txn: i16, address: &str, value: u64,
    ) -> Self {
        Self {
            txn_hash: txn_hash.to_vec(),
            txo,
            slot_no: slot_no.into(),
            txn,
            address: address.to_string(),
            value: value.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let txo_insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_UNSTAKED_TXO_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = txo_insert_queries {
            error!(error=%error,"Failed to prepare Insert TXO Asset Query.");
        };

        txo_insert_queries
    }
}
