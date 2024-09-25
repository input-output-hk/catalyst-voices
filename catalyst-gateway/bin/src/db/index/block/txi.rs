//! Insert TXI Index Data Queries.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQueries, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    settings::cassandra_db,
};

/// Insert TXI Query and Parameters
#[derive(SerializeRow, Debug)]
pub(crate) struct TxiInsertParams {
    /// Spent Transactions Hash
    txn_hash: Vec<u8>,
    /// TXO Index spent.
    txo: i16,
    /// Block Slot Number when spend occurred.
    slot_no: num_bigint::BigInt,
}

impl TxiInsertParams {
    /// Create a new record for this transaction.
    pub fn new(txn_hash: &[u8], txo: i16, slot_no: u64) -> Self {
        Self {
            txn_hash: txn_hash.to_vec(),
            txo,
            slot_no: slot_no.into(),
        }
    }
}

/// Insert TXI Query and Parameters
pub(crate) struct TxiInsertQuery {
    /// Transaction Input Data to be inserted.
    txi_data: Vec<TxiInsertParams>,
}

/// TXI by Txn hash Index
const INSERT_TXI_QUERY: &str = include_str!("./cql/insert_txi.cql");

impl TxiInsertQuery {
    /// Create a new record for this transaction.
    pub(crate) fn new() -> Self {
        Self {
            txi_data: Vec::new(),
        }
    }

    /// Prepare Batch of Insert TXI Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let txi_insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_TXI_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = txi_insert_queries {
            error!(error=%error,"Failed to prepare Insert TXI Query.");
        };

        txi_insert_queries
    }

    /// Index the transaction Inputs.
    pub(crate) fn index(&mut self, txs: &pallas_traverse::MultiEraTx<'_>, slot_no: u64) {
        // Index the TXI's.
        for txi in txs.inputs() {
            let txn_hash = txi.hash().to_vec();
            let txo: i16 = txi.index().try_into().unwrap_or(i16::MAX);

            self.txi_data
                .push(TxiInsertParams::new(&txn_hash, txo, slot_no));
        }
    }

    /// Execute the Certificate Indexing Queries.
    ///
    /// Consumes the `self` and returns a vector of futures.
    pub(crate) fn execute(self, session: &Arc<CassandraSession>) -> FallibleQueryTasks {
        let mut query_handles: FallibleQueryTasks = Vec::new();

        let inner_session = session.clone();

        query_handles.push(tokio::spawn(async move {
            inner_session
                .execute_batch(PreparedQuery::TxiInsertQuery, self.txi_data)
                .await
        }));

        query_handles
    }
}
