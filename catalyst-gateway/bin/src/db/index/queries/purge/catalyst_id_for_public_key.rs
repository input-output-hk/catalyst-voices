//! Catalyst ID for public key (RBAC 509 registrations) queries used in purging data.

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
        types::DbPublicKey,
    },
    settings::cassandra_db,
};

pub(crate) mod result {
    //! Return values for Catalyst ID for public key purge queries.

    use crate::db::types::{DbPublicKey, DbSlot};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (DbPublicKey, DbSlot);
}

/// Select primary keys for Catalyst ID for public key.
const SELECT_QUERY: &str = include_str!("cql/get_catalyst_id_for_public_key.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A public key.
    pub(crate) public_key: DbPublicKey,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("public_key", &self.public_key)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            public_key: value.0,
        }
    }
}
/// Get primary key for Catalyst ID for public key query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all Catalyst ID public key primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
            .await
            .inspect_err(
                |error| error!(error=%error, "Failed to prepare get 'Catalyst ID for public key' primary key query."),
            )
            .map_err(|error| anyhow::anyhow!("{error}\n--\n{SELECT_QUERY}"))
    }

    /// Executes a query to get all Catalyst ID for public key primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::CatalystIdForPublicKey)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete Catalyst ID for public key query.
const DELETE_QUERY: &str = include_str!("cql/delete_catalyst_id_for_public_key.cql");

/// Delete Catalyst ID for public key query.
pub(crate) struct DeleteQuery;

impl DeleteQuery {
    /// Prepares a batch of delete queries.
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
                |error| error!(error=%error, "Failed to prepare delete 'Catalyst ID for public key' registration primary key query."),
            )
            .map_err(|error| anyhow::anyhow!("{error}\n--\n{DELETE_QUERY}"))
    }

    /// Executes a DELETE query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::CatalystIdForPublicKey, params)
            .await?;

        Ok(results)
    }
}
