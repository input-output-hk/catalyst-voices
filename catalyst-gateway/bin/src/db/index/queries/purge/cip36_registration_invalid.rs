//! CIP-36 Registration (Invalid) Queries used in purging data.
use std::fmt::Debug;

use scylla::{transport::iterator::TypedRowStream, SerializeRow};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryResults, Query},
            session::CassandraSession,
        },
        types::{DbSlot, DbTxnIndex},
    },
    impl_query_batch, impl_query_statement,
};

pub(crate) mod result {
    //! Return values for CIP-36 invalid registration purge queries.

    use crate::db::types::{DbSlot, DbTxnIndex};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (Vec<u8>, DbSlot, DbTxnIndex);
}

/// Select primary keys for CIP-36 invalid registration.
const SELECT_QUERY: &str = include_str!("./cql/get_cip36_registration_invalid.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub(crate) stake_public_key: Vec<u8>,
    /// Block Slot Number
    pub(crate) slot_no: DbSlot,
    /// Transaction Offset inside the block.
    pub(crate) txn_index: DbTxnIndex,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_public_key", &self.stake_public_key)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            stake_public_key: value.0,
            slot_no: value.1,
            txn_index: value.2,
        }
    }
}
/// Get primary key for CIP-36 invalid registration query.
pub(crate) struct PrimaryKeyQuery;

impl_query_statement!(PrimaryKeyQuery, SELECT_QUERY);

impl PrimaryKeyQuery {
    /// Executes a query to get all CIP-36 invalid registration primary keys.
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

/// Delete CIP-36 invalid registration
const DELETE_QUERY: &str = include_str!("./cql/delete_cip36_registration_invalid.cql");

/// Delete CIP-36 invalid registration Query
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
