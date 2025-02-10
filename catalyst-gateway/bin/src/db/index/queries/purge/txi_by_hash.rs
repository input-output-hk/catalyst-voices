//! Transaction Inputs (ADA or a native asset) queries used in purging data.
use std::{fmt::Debug, sync::Arc};

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, SerializeRow,
    Session,
};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{
                purge::{PreparedDeleteQuery, PreparedQueries, PreparedSelectQuery},
                FallibleQueryResults, SizedBatch,
            },
            session::CassandraSession,
        },
        types::{DbTransactionHash, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

pub(crate) mod result {
    //! Return values for TXI by hash purge queries.

    use crate::db::types::{DbSlot, DbTransactionHash, DbTxnOutputOffset};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (DbTransactionHash, DbTxnOutputOffset, DbSlot);
}

/// Select primary keys for TXI by hash.
const SELECT_QUERY: &str = include_str!("./cql/get_txi_by_txn_hashes.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// 32 byte hash of this transaction.
    pub(crate) txn_hash: DbTransactionHash,
    /// Transaction Output Offset inside the transaction.
    pub(crate) txo: DbTxnOutputOffset,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("txn_hash", &self.txn_hash.to_string())
            .field("txo", &self.txo)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            txn_hash: value.0,
            txo: value.1,
        }
    }
}
/// Get primary key for TXI by hash query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all TXI by hash primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get TXI by hash primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{SELECT_QUERY}"))
    }

    /// Executes a query to get all TXI by hash primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::Txi)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete TXI by hash Query
const DELETE_QUERY: &str = include_str!("./cql/delete_txi_by_txn_hashes.cql");

/// Delete TXI by hash Query
pub(crate) struct DeleteQuery;

impl DeleteQuery {
    /// Prepare Batch of Delete Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            DELETE_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare delete TXI by hash primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{DELETE_QUERY}"))
    }

    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::Txi, params)
            .await?;

        Ok(results)
    }
}
