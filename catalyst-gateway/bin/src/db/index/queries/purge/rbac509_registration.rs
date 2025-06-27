//! RBAC 509 Registration Queries used in purging data.
use std::fmt::Debug;

use scylla::{transport::iterator::TypedRowStream, SerializeRow};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryResults, Query},
            session::CassandraSession,
        },
        types::{DbCatalystId, DbTransactionId},
    },
    impl_query_batch, impl_query_statement,
};

pub(crate) mod result {
    //! Return values for RBAC 509 registration purge queries.

    use crate::db::types::{DbCatalystId, DbSlot, DbTransactionId};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (DbCatalystId, DbTransactionId, DbSlot);
}

/// Select primary keys for RBAC 509 registration.
const SELECT_QUERY: &str = include_str!("cql/get_rbac_registration.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A short Catalyst ID.
    pub catalyst_id: DbCatalystId,
    /// A transaction ID.
    pub txn_id: DbTransactionId,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("catalyst_id", &self.catalyst_id)
            .field("txn_id", &self.txn_id)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            catalyst_id: value.0,
            txn_id: value.1,
        }
    }
}
/// Get primary key for RBAC 509 registration query.
pub(crate) struct PrimaryKeyQuery;

impl_query_statement!(PrimaryKeyQuery, SELECT_QUERY);

impl PrimaryKeyQuery {
    /// Executes a query to get all RBAC 509 registration primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(<Self as Query>::type_id())
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete RBAC 509 registration
const DELETE_QUERY: &str = include_str!("cql/delete_rbac_registration.cql");

/// Delete RBAC 509 registration Query
pub(crate) struct DeleteQuery;

impl_query_batch!(DeleteQuery, DELETE_QUERY);

impl DeleteQuery {
    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(
                <Self as Query>::type_id(),
                <Self as Query>::query_str(),
                params,
            )
            .await?;

        Ok(results)
    }
}
