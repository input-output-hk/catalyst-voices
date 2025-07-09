//! Stake Registration Queries used in purging data.
use std::fmt::Debug;

use scylla::{transport::iterator::TypedRowStream, SerializeRow};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryResults, Query},
            session::CassandraSession,
        },
        types::{DbSlot, DbStakeAddress, DbTxnIndex},
    },
    impl_query_batch, impl_query_statement,
};

pub(crate) mod result {
    //! Return values for Stake Registration purge queries.

    use crate::db::types::{DbSlot, DbStakeAddress, DbTxnIndex};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (DbStakeAddress, bool, DbSlot, DbTxnIndex);
}

/// Select primary keys for Stake Registration.
const SELECT_QUERY: &str = include_str!("./cql/get_stake_registration.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Stake hash - Binary 29 bytes.
    pub(crate) stake_address: DbStakeAddress,
    /// Is the address a script address.
    pub(crate) script: bool,
    /// Block Slot Number
    pub(crate) slot_no: DbSlot,
    /// Transaction Offset inside the block.
    pub(crate) txn_index: DbTxnIndex,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address)
            .field("script", &self.script)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            stake_address: value.0,
            script: value.1,
            slot_no: value.2,
            txn_index: value.3,
        }
    }
}
/// Get primary key for Stake Registration query.
pub(crate) struct PrimaryKeyQuery;

impl_query_statement!(PrimaryKeyQuery, SELECT_QUERY);

impl PrimaryKeyQuery {
    /// Executes a query to get all Stake Registration primary keys.
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

/// Delete Stake Registration
const DELETE_QUERY: &str = include_str!("./cql/delete_stake_registration.cql");

/// Delete Stake Registration Query
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
