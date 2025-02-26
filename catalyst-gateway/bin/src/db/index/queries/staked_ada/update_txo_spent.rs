//! Update the TXO Spent column to optimize future queries.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryResults, PreparedQueries, PreparedQuery, SizedBatch},
            session::CassandraSession,
        },
        types::{DbSlot, DbStakeAddress, DbTxnIndex, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

/// Update TXO spent query string.
const UPDATE_TXO_SPENT_QUERY: &str = include_str!("../cql/update_txo_spent.cql");

/// Update TXO spent query params.
#[derive(SerializeRow, Debug)]
pub(crate) struct UpdateTxoSpentQueryParams {
    /// TXO stake address.
    pub stake_address: DbStakeAddress,
    /// TXO transaction index within the slot.
    pub txn_index: DbTxnIndex,
    /// TXO index.
    pub txo: DbTxnOutputOffset,
    /// TXO slot number.
    pub slot_no: DbSlot,
    /// TXO spent slot number.
    pub spent_slot: DbSlot,
}

/// Update TXO spent query.
pub(crate) struct UpdateTxoSpentQuery;

impl UpdateTxoSpentQuery {
    /// Prepare a batch of update TXO spent queries.
    pub(crate) async fn prepare_batch(
        session: Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            UPDATE_TXO_SPENT_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare update TXO spent query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{UPDATE_TXO_SPENT_QUERY}"))
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
