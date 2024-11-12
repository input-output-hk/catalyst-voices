//! TXO by Stake Address Queries used in purging data.
use std::{fmt::Debug, sync::Arc};

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowIterator, FromRow,
    SerializeRow, Session,
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

/// Select primary keys for TXO by Stake Address.
const SELECT_QUERY: &str = include_str!("../cql/get_txo_by_stake_address.cql");

/// Primary Key Row
#[derive(FromRow, SerializeRow, Clone)]
#[allow(dead_code)]
pub(crate) struct PrimaryKey {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    pub(crate) stake_address: Vec<u8>,
    /// Block Slot Number
    pub(crate) slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    pub(crate) txn: i16,
    /// Transaction Output Offset inside the transaction.
    pub(crate) txo: i16,
}

impl Debug for PrimaryKey {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("txo", &self.txo)
            .finish()
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
    #[allow(dead_code)]
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowIterator<PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::TxoAda)
            .await?
            .into_typed::<PrimaryKey>();

        Ok(iter)
    }
}

/// Delete TXO by Stake Address
const DELETE_QUERY: &str = include_str!("../cql/delete_txo_by_stake_address.cql");

/// Delet;e TXO by Stake Address Query
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
    #[allow(dead_code)]
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<PrimaryKey>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::TxoAda, params)
            .await?;

        Ok(results)
    }
}
