//! Catalyst ID For Stake Address (RBAC 509 registrations) Queries used in purging data.

use std::fmt::Debug;

use scylla::{transport::iterator::TypedRowStream, SerializeRow};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryResults, Query},
            session::CassandraSession,
        },
        types::DbStakeAddress,
    },
    impl_query_batch, impl_query_statement,
};

pub(crate) mod result {
    //! Return values for Catalyst ID For Stake Address registration purge queries.

    use crate::db::types::{DbSlot, DbStakeAddress};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (DbStakeAddress, DbSlot);
}

/// Select primary keys for Catalyst ID For Stake Address registration.
const SELECT_QUERY: &str = include_str!("cql/get_catalyst_id_for_stake_address.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A stake address.
    pub(crate) stake_address: DbStakeAddress,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address.to_string())
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            stake_address: value.0,
        }
    }
}
/// Get primary key for Catalyst ID For Stake Address registration query.
pub(crate) struct PrimaryKeyQuery;

impl_query_statement!(PrimaryKeyQuery, SELECT_QUERY);

impl PrimaryKeyQuery {
    /// Executes a query to get all Catalyst ID For Stake Address registration primary
    /// keys.
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

/// Delete Catalyst ID For Stake Address registration
const DELETE_QUERY: &str = include_str!("cql/delete_catalyst_id_for_stake_address.cql");

/// Delete Catalyst ID For Stake Address registration Query
pub(crate) struct DeleteQuery;

impl_query_batch!(DeleteQuery, DELETE_QUERY);

impl DeleteQuery {
    /// Prepare Batch of Delete Queries
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
