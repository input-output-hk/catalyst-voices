//! Catalyst ID For TX ID (RBAC 509 registrations) Queries used in purging data.

use std::fmt::Debug;

use scylla::{transport::iterator::TypedRowStream, SerializeRow};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryResults, Query},
            session::CassandraSession,
        },
        types::DbTransactionId,
    },
    impl_query_batch, impl_query_statement,
};

pub(crate) mod result {
    //! Return values for Catalyst ID For TX ID registration purge queries.
    use scylla::DeserializeRow;

    use crate::db::types::DbTransactionId;

    /// Primary Key Row
    #[derive(DeserializeRow)]
    pub(crate) struct PrimaryKey {
        /// A transaction hash.
        pub(crate) txn_id: DbTransactionId,
    }
}

/// Select primary keys for Catalyst ID For TX ID registration.
const SELECT_QUERY: &str = include_str!("cql/get_catalyst_id_for_txn_id.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A transaction hash.
    pub(crate) txn_id: DbTransactionId,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("txn_id", &self.txn_id.to_string())
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            txn_id: value.txn_id,
        }
    }
}

/// Get primary key for Catalyst ID For TX ID registration query.
pub(crate) struct PrimaryKeyQuery;

impl_query_statement!(PrimaryKeyQuery, SELECT_QUERY);

impl PrimaryKeyQuery {
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

/// Delete Catalyst ID For TX ID registration
const DELETE_QUERY: &str = include_str!("cql/delete_catalyst_id_for_txn_id.cql");

/// Delete Catalyst ID For TX ID registration Query
pub(crate) struct DeleteQuery;

impl_query_batch!(DeleteQuery, DELETE_QUERY);

impl DeleteQuery {
    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(Self::type_id(), Self::query_str(), params)
            .await?;

        Ok(results)
    }
}
