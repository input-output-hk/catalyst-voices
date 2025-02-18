//! Insert Unstaked TXO Native Assets into the DB.

use std::sync::Arc;

use cardano_blockchain_types::{Slot, TransactionHash, TxnIndex, TxnOutputOffset};
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbTransactionId, DbTxnIndex, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

/// Unstaked TXO Asset by Stake Address Indexing Query
const INSERT_UNSTAKED_TXO_ASSET_QUERY: &str = include_str!("./cql/insert_unstaked_txo_asset.cql");

/// Insert TXO Asset Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow, Debug)]
pub(crate) struct Params {
    /// Transactions hash.
    txn_id: DbTransactionId,
    /// Transaction Output Offset inside the transaction.
    txo: DbTxnOutputOffset,
    /// Policy hash of the asset
    policy_id: Vec<u8>,
    /// Policy name of the asset
    asset_name: Vec<u8>,
    /// Block Slot Number
    slot_no: DbSlot,
    /// Transaction Offset inside the block.
    txn_index: DbTxnIndex,
    /// Value of the asset
    value: num_bigint::BigInt,
}

impl Params {
    /// Create a new record for this transaction.
    ///
    /// Note Value can be either a u64 or an i64, so use a i128 to represent all possible
    /// values.
    #[allow(clippy::too_many_arguments)]
    pub(crate) fn new(
        txn_id: TransactionHash, txo: TxnOutputOffset, policy_id: &[u8], asset_name: &[u8],
        slot_no: Slot, txn_index: TxnIndex, value: i128,
    ) -> Self {
        Self {
            txn_id: txn_id.into(),
            txo: txo.into(),
            policy_id: policy_id.to_vec(),
            asset_name: asset_name.to_vec(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            value: value.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_UNSTAKED_TXO_ASSET_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error,"Failed to prepare Insert Unstaked TXO Asset Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_UNSTAKED_TXO_ASSET_QUERY}"))
    }
}
