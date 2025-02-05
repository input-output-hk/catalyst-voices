//! Insert TXO Native Assets into the DB.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::cassandra_db,
};

/// TXO Asset by Stake Address Indexing Query
const INSERT_TXO_ASSET_QUERY: &str = include_str!("./cql/insert_txo_asset.cql");

/// Insert TXO Asset Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow, Debug)]
pub(crate) struct Params {
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
        stake_address: &[u8], slot_no: u64, txn: i16, txo: i16, policy_id: &[u8],
        asset_name: &[u8], value: i128,
    ) -> Self {
        Self {
            stake_address: stake_address.to_vec(),
            slot_no: slot_no.into(),
            txn,
            txo,
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
