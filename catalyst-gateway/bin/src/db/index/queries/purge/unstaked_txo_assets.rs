//! TXO Assets by TXN Hash Queries used in purging data.
use std::{fmt::Debug, sync::Arc};

use scylla::{
    client::{pager::TypedRowStream, session::Session},
    statement::prepared::PreparedStatement,
    SerializeRow,
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
        types::{DbTransactionId, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

pub(crate) mod result {
    //! Return values for TXO Assets by TXN Hash purge queries.

    use crate::db::types::{DbTransactionId, DbTxnOutputOffset};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (
        DbTransactionId,
        DbTxnOutputOffset,
        Vec<u8>,
        Vec<u8>,
        num_bigint::BigInt,
    );
}

/// Select primary keys for TXO Assets by TXN Hash.
const SELECT_QUERY: &str = include_str!("./cql/get_unstaked_txo_assets_by_txn_hash.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// 32 byte hash of this transaction.
    pub(crate) txn_id: DbTransactionId,
    /// Offset in the txo list of the transaction the txo is in.
    pub(crate) txo: DbTxnOutputOffset,
    /// Asset policy hash (28 bytes).
    pub(crate) policy_id: Vec<u8>,
    /// Asset name (range of 0 - 32 bytes).
    pub(crate) asset_name: Vec<u8>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("txn_id", &self.txn_id)
            .field("txo", &self.txo)
            .field("policy_id", &self.policy_id)
            .field("asset_name", &self.asset_name)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            txn_id: value.0,
            txo: value.1,
            policy_id: value.2,
            asset_name: value.3,
        }
    }
}
/// Get primary key for TXO Assets by TXN Hash query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all TXO Assets by TXN Hash primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get TXO Assets by TXN Hash primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{SELECT_QUERY}"))
    }

    /// Executes a query to get all TXO Assets by TXN Hash primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::UnstakedTxoAsset)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete TXO Assets by TXN Hash
const DELETE_QUERY: &str = include_str!("./cql/delete_unstaked_txo_assets_by_txn_hash.cql");

/// Delete TXO Assets by TXN Hash Query
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
            |error| error!(error=%error, "Failed to prepare delete TXO Assets by TXN Hash primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{DELETE_QUERY}"))
    }

    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::UnstakedTxoAsset, params)
            .await?;

        Ok(results)
    }
}
