//! Unstaked Transaction Outputs (ADA), by their transaction hash, queries used in purging
//! data.
use std::{fmt::Debug, sync::Arc};

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, SerializeRow,
    Session,
};
use tracing::error;

use crate::{
    db::index::{
        queries::{
            purge::{PreparedDeleteQuery, PreparedQueries, PreparedSelectQuery},
            FallibleQueryResults, SizedBatch,
        },
        session::CassandraSession,
    },
    settings::cassandra_db,
};

pub(crate) mod result {
    //! Return values for Unstaked TXO ADA purge queries.

    /// Primary Key Row
    pub(crate) type PrimaryKey = (Vec<u8>, i16);
}

/// Select primary keys for Unstaked TXO ADA.
const SELECT_QUERY: &str = include_str!("./cql/get_unstaked_txo_by_txn_hash.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// 32 byte hash of this transaction.
    pub(crate) txn_hash: Vec<u8>,
    /// Transaction Output Offset inside the transaction.
    pub(crate) txo: i16,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("txn_hash", &self.txn_hash)
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
/// Get primary key for Unstaked TXO ADA query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all Unstaked TXO ADA primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let select_primary_key = PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = select_primary_key {
            error!(error=%error, "Failed to prepare get Unstaked TXO ADA primary key query");
        };

        select_primary_key
    }

    /// Executes a query to get all Unstaked TXO ADA primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::UnstakedTxoAda)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete Unstaked TXO by Stake Address
const DELETE_QUERY: &str = include_str!("./cql/delete_unstaked_txo_by_txn_hash.cql");

/// Delete TXO by Stake Address Query
pub(crate) struct DeleteQuery;

impl DeleteQuery {
    /// Prepare Batch of Delete Queries
    pub(crate) async fn prepare_batch(
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
