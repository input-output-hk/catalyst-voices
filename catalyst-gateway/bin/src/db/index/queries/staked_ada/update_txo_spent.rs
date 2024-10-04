//! Update the TXO Spent column to optimize future queries.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::{
        queries::{FallibleQueryResults, PreparedQueries, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    settings::cassandra_db,
};

/// Update TXO spent query string.
const UPDATE_TXO_SPENT_QUERY: &str = include_str!("../cql/update_txo_spent.cql");

/// Update TXO spent query params.
#[derive(SerializeRow, Debug)]
pub(crate) struct UpdateTxoSpentQueryParams {
    /// TXO stake address.
    pub stake_address: Vec<u8>,
    /// TXO transaction index within the slot.
    pub txn: i16,
    /// TXO index.
    pub txo: i16,
    /// TXO slot number.
    pub slot_no: num_bigint::BigInt,
    /// TXO spent slot number.
    pub spent_slot: num_bigint::BigInt,
}

/// Update TXO spent query.
pub(crate) struct UpdateTxoSpentQuery;

impl UpdateTxoSpentQuery {
    /// Prepare a batch of update TXO spent queries.
    pub(crate) async fn prepare_batch(
        session: Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let update_txo_spent_queries = PreparedQueries::prepare_batch(
            session.clone(),
            UPDATE_TXO_SPENT_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = update_txo_spent_queries {
            error!(error=%error,"Failed to prepare update TXO spent query.");
        };

        update_txo_spent_queries
    }

    /// Executes a update txo spent query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<UpdateTxoSpentQueryParams>,
    ) -> FallibleQueryResults {
        let results = session
            .execute_batch(PreparedQuery::TxoSpentUpdateQuery, params)
            .await?;

        Ok(results)
    }
}
