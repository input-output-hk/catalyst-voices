//! Insert TXO Native Assets into the DB.

use std::sync::Arc;

use cardano_blockchain_types::{Slot, StakeAddress, TxnIndex, TxnOutputOffset};
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbStakeAddress, DbTxnIndex, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

/// TXO Asset by Stake Address Indexing Query
const INSERT_TXO_ASSET_QUERY: &str = include_str!("./cql/insert_txo_asset.cql");

/// Insert TXO Asset Query Parameters
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
    /// Policy hash of the asset
    policy_id: Vec<u8>,
    /// Name of the asset, within the Policy.
    asset_name: Vec<u8>,
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
        stake_address: StakeAddress, slot_no: Slot, txn_index: TxnIndex, txo: TxnOutputOffset,
        policy_id: &[u8], asset_name: &[u8], value: i128,
    ) -> Self {
        Self {
            stake_address: stake_address.into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            txo: txo.into(),
            policy_id: policy_id.to_vec(),
            asset_name: asset_name.to_vec(),
            value: value.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_TXO_ASSET_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(|error| error!(error=%error,"Failed to prepare Insert TXO Asset Query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_TXO_ASSET_QUERY}"))
    }
}
