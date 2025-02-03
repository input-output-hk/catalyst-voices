//! Chain Root For TX ID (RBAC 509 registrations) Queries used in purging data.
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
    //! Return values for Chain Root For TX ID registration purge queries.
    use scylla::DeserializeRow;

    /// Primary Key Row
    #[derive(DeserializeRow)]
    pub(crate) struct PrimaryKey {
        /// TXN ID HASH - Binary 32 bytes.
        pub(crate) transaction_id: Vec<u8>,
    }
}

/// Select primary keys for Chain Root For TX ID registration.
const SELECT_QUERY: &str = include_str!("./cql/get_chain_root_for_txn_id.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// TXN ID HASH - Binary 32 bytes.
    pub(crate) transaction_id: Vec<u8>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("transaction_id", &hex::encode(&self.transaction_id))
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            transaction_id: value.transaction_id,
        }
    }
}
/// Get primary key for Chain Root For TX ID registration query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all Chain Root For TX ID registration primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get Chain Root For TX ID registration primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{SELECT_QUERY}"))
    }

    /// Executes a query to get all Chain Root For TX ID registration primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::ChainRootForTxnId)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete Chain Root For TX ID registration
const DELETE_QUERY: &str = include_str!("./cql/delete_chain_root_for_txn_id.cql");

/// Delete Chain Root For TX ID registration Query
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
            |error| error!(error=%error, "Failed to prepare delete Chain Root For TX ID registration primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{DELETE_QUERY}"))
    }

    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::ChainRootForTxnId, params)
            .await?;

        Ok(results)
    }
}
