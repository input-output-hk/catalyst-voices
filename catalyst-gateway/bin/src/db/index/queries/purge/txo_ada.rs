//! TXO by Stake Address Queries used in purging data.
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
    //! Return values for TXO by Stake Address purge queries.

    use crate::db::types::{DbSlot, DbTxnIndex};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (Vec<u8>, DbSlot, DbTxnIndex, i16);
}

/// Select primary keys for TXO by Stake Address.
const SELECT_QUERY: &str = include_str!("./cql/get_txo_by_stake_address.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    pub(crate) stake_address: Vec<u8>,
    /// Block Slot Number
    pub(crate) slot_no: DbSlot,
    /// Transaction Offset inside the block.
    pub(crate) txn: DbTxnIndex,
    /// Transaction Output Offset inside the transaction.
    pub(crate) txo: i16,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("txo", &self.txo)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            stake_address: value.0,
            slot_no: value.1,
            txn: value.2,
            txo: value.3,
        }
    }
}
/// Get primary key for TXO by Stake Address query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all TXO by stake address primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let select_primary_key = PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = select_primary_key {
            error!(error=%error, "Failed to prepare get TXO by stake address primary key query");
        };

        select_primary_key
    }

    /// Executes a query to get all TXO by stake address primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::TxoAda)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete TXO by Stake Address
const DELETE_QUERY: &str = include_str!("./cql/delete_txo_by_stake_address.cql");

/// Delete TXO by Stake Address Query
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
