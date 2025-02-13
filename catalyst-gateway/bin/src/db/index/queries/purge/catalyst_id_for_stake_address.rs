//! Catalyst ID For Stake Address (RBAC 509 registrations) Queries used in purging data.
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
        types::{DbCip19StakeAddress, DbSlot, DbTxnIndex},
    },
    settings::cassandra_db,
};

pub(crate) mod result {
    //! Return values for Catalyst ID For Stake Address registration purge queries.

    use crate::db::types::{DbCip19StakeAddress, DbSlot, DbTxnIndex};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (DbCip19StakeAddress, DbSlot, DbTxnIndex);
}

/// Select primary keys for Catalyst ID For Stake Address registration.
const SELECT_QUERY: &str = include_str!("cql/get_catalyst_id_for_stake_addr.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A stake address.
    pub(crate) stake_addr: DbCip19StakeAddress,
    /// Block Slot Number
    pub(crate) slot_no: DbSlot,
    /// Transaction Offset inside the block.
    pub(crate) txn_index: DbTxnIndex,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_addr", &hex::encode(&self.stake_addr))
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            stake_addr: value.0,
            slot_no: value.1,
            txn_index: value.2,
        }
    }
}
/// Get primary key for Catalyst ID For Stake Address registration query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all Catalyst ID For Stake Address registration primary
    /// keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get Catalyst ID For Stake Address registration primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{SELECT_QUERY}"))
    }

    /// Executes a query to get all Catalyst ID For Stake Address registration primary
    /// keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::CatalystIdForStakeAddress)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete Catalyst ID For Stake Address registration
const DELETE_QUERY: &str = include_str!("cql/delete_catalyst_id_for_stake_addr.cql");

/// Delete Catalyst ID For Stake Address registration Query
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
            |error| error!(error=%error, "Failed to prepare delete Catalyst ID For Stake Address registration primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{DELETE_QUERY}"))
    }

    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::CatalystIdForStakeAddress, params)
            .await?;

        Ok(results)
    }
}
