//! Insert TXO Indexed Data Queries.
//!
//! Note, there are multiple ways TXO Data is indexed and they all happen in here.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::CassandraEnvVars,
};

/// TXO by Stake Address Indexing query
const INSERT_TXO_QUERY: &str = include_str!("./cql/insert_txo.cql");

/// Insert TXO Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow)]
pub(super) struct Params {
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

impl Params {
    /// Create a new record for this transaction.
    pub(super) fn new(
        stake_address: &[u8], slot_no: u64, txn: i16, txo: i16, address: &str, value: u64,
        txn_hash: &[u8],
    ) -> Self {
        Self {
            stake_address: stake_address.to_vec(),
            slot_no: slot_no.into(),
            txn,
            txo,
            address: address.to_string(),
            value: value.into(),
            txn_hash: txn_hash.to_vec(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let txo_insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_TXO_QUERY,
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
