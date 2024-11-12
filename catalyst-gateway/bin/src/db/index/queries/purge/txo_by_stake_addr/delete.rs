//! Delete queries for TXO by Stake Address.
use std::{fmt::Debug, sync::Arc};

use scylla::{SerializeRow, Session};

use crate::{
    db::index::{queries::{purge::{PreparedDeleteQuery, PreparedQueries}, FallibleQueryResults, SizedBatch}, session::CassandraSession},
    settings::cassandra_db,
};

/// Delete TXO by Stake Address
const DELETE_QUERY: &str = include_str!("../cql/delete_txo_by_stake_address.cql");

/// Get TXO by Stake Address Query Parameters
#[derive(SerializeRow, Clone)]
pub(super) struct Params {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("txo", &self.txo)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(super) fn new(stake_address: &[u8], slot_no: u64, txn: i16, txo: i16) -> Self {
        Self {
            stake_address: stake_address.to_vec(),
            slot_no: slot_no.into(),
            txn,
            txo,
        }
    }
}

/// Delet;e TXO by Stake Address Query
pub(crate) struct DeleteQuery;

impl DeleteQuery {
    /// Prepare Batch of Delete Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let delete_queries = PreparedQueries::prepare_batch(
            session.clone(),
            DELETE_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await?;
        Ok(delete_queries)
    }

    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::TxoAda, params)
            .await?;

        Ok(results)
    }
}
