//! Insert Unstaked TXO Native Assets into the DB.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::cassandra_db,
};

/// Unstaked TXO Asset by Stake Address Indexing Query
const INSERT_UNSTAKED_TXO_ASSET_QUERY: &str = include_str!("./cql/insert_unstaked_txo_asset.cql");

/// Insert TXO Asset Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow, Debug)]
pub(super) struct Params {
    /// Transactions hash.
    txn_hash: Vec<u8>,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Policy hash of the asset
    policy_id: Vec<u8>,
    /// Policy name of the asset
    asset_name: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Value of the asset
    value: num_bigint::BigInt,
}

impl Params {
    /// Create a new record for this transaction.
    ///
    /// Note Value can be either a u64 or an i64, so use a i128 to represent all possible
    /// values.
    #[allow(clippy::too_many_arguments)]
    pub(super) fn new(
        txn_hash: &[u8], txo: i16, policy_id: &[u8], asset_name: &str, slot_no: u64, txn: i16,
        value: i128,
    ) -> Self {
        Self {
            txn_hash: txn_hash.to_vec(),
            txo,
            policy_id: policy_id.to_vec(),
            asset_name: asset_name.as_bytes().to_vec(),
            slot_no: slot_no.into(),
            txn,
            value: value.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let txo_insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_UNSTAKED_TXO_ASSET_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = txo_insert_queries {
            error!(error=%error,"Failed to prepare Insert Unstaked TXO Asset Query.");
        };

        txo_insert_queries
    }
}
