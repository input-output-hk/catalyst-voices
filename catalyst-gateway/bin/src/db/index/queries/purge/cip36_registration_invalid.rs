//! CIP-36 Registration (Invalid) Queries used in purging data.
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
        types::{DbSlot, DbTxnIndex},
    },
    settings::cassandra_db,
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

impl PrimaryKeyQuery {
    /// Prepares a query to get all CIP-36 invalid registration primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get CIP-36 invalid registration primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{SELECT_QUERY}"))
    }

    /// Executes a query to get all CIP-36 invalid registration primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::Cip36RegistrationInvalid)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete CIP-36 invalid registration
const DELETE_QUERY: &str = include_str!("./cql/delete_cip36_registration_invalid.cql");

/// Delete CIP-36 invalid registration Query
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
            |error| error!(error=%error, "Failed to prepare delete CIP-36 invalid registration primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{DELETE_QUERY}"))
    }

    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::Cip36RegistrationInvalid, params)
            .await?;

        Ok(results)
    }
}
