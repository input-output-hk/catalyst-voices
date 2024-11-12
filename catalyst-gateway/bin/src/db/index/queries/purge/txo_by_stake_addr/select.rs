//! Select queries for TXO by Stake Address.

use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowIterator, FromRow,
    Session,
};
use tracing::error;

use crate::db::index::{
    queries::purge::{PreparedQueries, PreparedSelectQuery},
    session::CassandraSession,
};

/// Select primary keys for TXO by Stake Address.
const SELECT_QUERY: &str = include_str!("../cql/get_txo_by_stake_address.cql");

/// Primary Key Row
#[derive(FromRow)]
pub(crate) struct PrimaryKey {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
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
    ) -> anyhow::Result<TypedRowIterator<PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::TxoAda)
            .await?
            .into_typed::<PrimaryKey>();

        Ok(iter)
    }
}
