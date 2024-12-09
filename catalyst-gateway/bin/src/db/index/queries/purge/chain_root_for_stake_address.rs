//! Chain Root For Role0 Key (RBAC 509 registrations) Queries used in purging data.
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
    //! Return values for Chain Root For Role0 Key registration purge queries.

    /// Primary Key Row
    pub(crate) type PrimaryKey = (Vec<u8>, num_bigint::BigInt, i16);
}

/// Select primary keys for Chain Root For Role0 Key registration.
const SELECT_QUERY: &str = include_str!("./cql/get_chain_root_for_role0_key.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Role0 Key - Binary 16 bytes.
    pub(crate) role0_key: Vec<u8>,
    /// Block Slot Number
    pub(crate) slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    pub(crate) txn: i16,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("role0_key", &self.role0_key)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            role0_key: value.0,
            slot_no: value.1,
            txn: value.2,
        }
    }
}
/// Get primary key for Chain Root For Role0 Key registration query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all Chain Root For Role0 Key registration primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let select_primary_key = PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = select_primary_key {
            error!(error=%error, "Failed to prepare get Chain Root For Role0 Key registration primary key query");
        };

        select_primary_key
    }

    /// Executes a query to get all Chain Root For Role0 Key registration primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::ChainRootForStakeAddress)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete Chain Root For Role0 Key registration
const DELETE_QUERY: &str = include_str!("./cql/delete_chain_root_for_role0_key.cql");

/// Delete Chain Root For Role0 Key registration Query
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
            .purge_execute_batch(PreparedDeleteQuery::ChainRootForStakeAddress, params)
            .await?;

        Ok(results)
    }
}
