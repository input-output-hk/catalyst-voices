//! RBAC 509 Registration Queries used in purging data.
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
        types::{DbCatalystId, DbSlot, DbTransactionHash, DbTxnIndex},
    },
    settings::cassandra_db,
};

pub(crate) mod result {
    //! Return values for RBAC 509 registration purge queries.

    use crate::db::types::{DbCatalystId, DbSlot, DbTransactionHash, DbTxnIndex};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (DbCatalystId, DbTransactionHash, DbSlot, DbTxnIndex);
}

/// Select primary keys for RBAC 509 registration.
const SELECT_QUERY: &str = include_str!("cql/get_rbac_registration.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A short Catalyst ID.
    pub catalyst_id: DbCatalystId,
    /// A transaction ID.
    pub txn_id: DbTransactionHash,
    /// Block Slot Number
    pub slot_no: DbSlot,
    /// Transaction Offset inside the block.
    pub txn_index: DbTxnIndex,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("catalyst_id", &self.catalyst_id)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("transaction_id", &self.txn_id)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            catalyst_id: value.0,
            txn_id: value.1,
            slot_no: value.2,
            txn_index: value.3,
        }
    }
}
/// Get primary key for RBAC 509 registration query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all RBAC 509 registration primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get RBAC 509 registration primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{SELECT_QUERY}"))
    }

    /// Executes a query to get all RBAC 509 registration primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::Rbac509)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete RBAC 509 registration
const DELETE_QUERY: &str = include_str!("cql/delete_rbac_registration.cql");

/// Delete RBAC 509 registration Query
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
            |error| error!(error=%error, "Failed to prepare delete RBAC 509 registration primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{DELETE_QUERY}"))
    }

    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::Rbac509, params)
            .await?;

        Ok(results)
    }
}
