//! CIP-36 registration by Vote Key Queries used in purging data.
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
    //! Return values for CIP-36 registration by Vote key purge queries.

    /// Primary Key Row
    pub(crate) type PrimaryKey = (Vec<u8>, Vec<u8>, num_bigint::BigInt, i16, bool);
}

/// Select primary keys for CIP-36 registration by Vote key.
const SELECT_QUERY: &str = include_str!("./cql/get_cip36_registration_for_vote_key.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Vote key - Binary 28 bytes.
    pub(crate) vote_key: Vec<u8>,
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    pub(crate) stake_address: Vec<u8>,
    /// Block Slot Number
    pub(crate) slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    pub(crate) txn: i16,
    /// True if registration is valid.
    pub(crate) valid: bool,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("vote_key", &self.vote_key)
            .field("stake_address", &self.stake_address)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("valid", &self.valid)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            vote_key: value.0,
            stake_address: value.1,
            slot_no: value.2,
            txn: value.3,
            valid: value.4,
        }
    }
}
/// Get primary key for CIP-36 registration by Vote key query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all CIP-36 registration by Vote key primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let select_primary_key = PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = select_primary_key {
            error!(error=%error, "Failed to prepare get CIP-36 registration by Vote key primary key query");
        };

        select_primary_key
    }

    /// Executes a query to get all CIP-36 registration by Vote key primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::Cip36RegistrationForVoteKey)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete CIP-36 registration
const DELETE_QUERY: &str = include_str!("./cql/delete_cip36_registration_for_vote_key.cql");

/// Delete CIP-36 registration by Vote key Query
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
            .purge_execute_batch(PreparedDeleteQuery::Cip36RegistrationForVoteKey, params)
            .await?;

        Ok(results)
    }
}
