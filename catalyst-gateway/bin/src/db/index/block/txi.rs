//! Insert TXI Index Data Queries.

use std::sync::Arc;

use cardano_blockchain_types::{Slot, TransactionId, TxnOutputOffset};
use catalyst_types::hashes::Blake2b256Hash;
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryTasks, PreparedQueries, PreparedQuery, SizedBatch},
            session::CassandraSession,
        },
        types::{DbSlot, DbTransactionId, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

/// Insert TXI Query and Parameters
#[derive(SerializeRow, Debug)]
pub(crate) struct TxiInsertParams {
    /// Spent Transactions Hash
    txn_id: DbTransactionId,
    /// TXO Index spent.
    txo: DbTxnOutputOffset,
    /// Block Slot Number when spend occurred.
    slot_no: DbSlot,
}

impl TxiInsertParams {
    /// Create a new record for this transaction.
    pub fn new(txn_id: TransactionId, txo: TxnOutputOffset, slot: Slot) -> Self {
        Self {
            txn_id: txn_id.into(),
            txo: txo.into(),
            slot_no: slot.into(),
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
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_TXI_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(|error| error!(error=%error,"Failed to prepare Insert TXI Query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_TXI_QUERY}"))
    }

    /// Index the transaction Inputs.
    pub(crate) fn index(&mut self, txs: &pallas_traverse::MultiEraTx<'_>, slot_no: Slot) {
        // Index the TXI's.
        for txi in txs.inputs() {
            let txn_id = Blake2b256Hash::from(*txi.hash()).into();
            let txo = txi.index().try_into().unwrap_or(i16::MAX).into();

            self.txi_data
                .push(TxiInsertParams::new(txn_id, txo, slot_no));
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
