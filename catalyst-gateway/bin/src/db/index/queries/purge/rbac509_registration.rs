//! RBAC 509 Registration Queries used in purging data.
use std::{fmt::Debug, sync::Arc};

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowIterator, SerializeRow,
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
    //! Return values for RBAC 509 registration purge queries.

    /// Primary Key Row
    pub(crate) type PrimaryKey = (Vec<u8>, num_bigint::BigInt, i16, Vec<u8>, Vec<u8>);
}

/// Select primary keys for RBAC 509 registration.
const SELECT_QUERY: &str = include_str!("./cql/get_rbac509_registration.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Chain Root - Binary 32 bytes.
    pub(crate) chain_root: Vec<u8>,
    /// Block Slot Number
    pub(crate) slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    pub(crate) txn: i16,
    /// Transaction Hash ID - Binary 32 bytes.
    transaction_id: Vec<u8>,
    /// `UUIDv4` Purpose - Binary 16 bytes.
    purpose: Vec<u8>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("chain_root", &self.chain_root)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("transaction_id", &self.transaction_id)
            .field("purpose", &self.purpose)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            chain_root: value.0,
            slot_no: value.1,
            txn: value.2,
            transaction_id: value.3,
            purpose: value.4,
        }
    }
}
/// Get primary key for RBAC 509 registration query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all RBAC 509 registration primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let select_primary_key = PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = select_primary_key {
            error!(error=%error, "Failed to prepare get RBAC 509 registration primary key query");
        };

        select_primary_key
    }

    /// Executes a query to get all RBAC 509 registration primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowIterator<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::TxoAda)
            .await?
            .into_typed::<result::PrimaryKey>();

        Ok(iter)
    }
}

/// Delete RBAC 509 registration
const DELETE_QUERY: &str = include_str!("./cql/delete_rbac509_registration.cql");

/// Delete RBAC 509 registration Query
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
