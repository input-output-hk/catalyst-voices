//! CIP-36 registration by Vote Key Queries used in purging data.
use std::fmt::Debug;

use scylla::{transport::iterator::TypedRowStream, SerializeRow, Session};
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
    //! Return values for CIP-36 registration by Vote key purge queries.

    use crate::db::types::{DbSlot, DbTxnIndex};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (Vec<u8>, Vec<u8>, DbSlot, DbTxnIndex, bool);
}

/// Select primary keys for CIP-36 registration by Vote key.
const SELECT_QUERY: &str = include_str!("./cql/get_cip36_registration_for_vote_key.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Vote key - Binary 32 bytes.
    pub(crate) vote_key: Vec<u8>,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub(crate) stake_public_key: Vec<u8>,
    /// Block Slot Number
    pub(crate) slot_no: DbSlot,
    /// Transaction Offset inside the block.
    pub(crate) txn_index: DbTxnIndex,
    /// True if registration is valid.
    pub(crate) valid: bool,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("vote_key", &self.vote_key)
            .field("stake_public_key", &self.stake_public_key)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("valid", &self.valid)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            vote_key: value.0,
            stake_public_key: value.1,
            slot_no: value.2,
            txn_index: value.3,
            valid: value.4,
        }
    }
}
/// Get primary key for CIP-36 registration by Vote key query.
pub(crate) struct PrimaryKeyQuery;

impl_query_statement!(PrimaryKeyQuery, SELECT_QUERY);

impl PrimaryKeyQuery {
    /// Executes a query to get all CIP-36 registration by Vote key primary keys.
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

/// Delete CIP-36 registration
const DELETE_QUERY: &str = include_str!("./cql/delete_cip36_registration_for_vote_key.cql");

/// Delete CIP-36 registration by Vote key Query
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
