//! Get Catalyst ID by transaction ID.

use std::sync::Arc;

use anyhow::{Context, Result};
use futures::StreamExt;
use scylla::{
    prepared_statement::PreparedStatement, statement::Consistency, DeserializeRow, SerializeRow,
    Session,
};
use tracing::error;

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::{DbCatalystId, DbSlot, DbTransactionId},
};

/// A query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_transaction_id.cql");

/// Get Catalyst ID by transaction ID query parameters.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// A transaction hash.
    pub(crate) txn_id: DbTransactionId,
}

/// Get Catalyst ID by transaction ID query.
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct Query {
    /// A Catalyst ID.
    pub catalyst_id: DbCatalystId,
    /// A slot number.
    pub slot_no: DbSlot,
}

impl Query {
    /// Prepares a "get catalyst ID by transaction ID" query.
    pub(crate) async fn prepare(session: Arc<Session>) -> Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get Catalyst ID by transaction ID query"),
            )
    }

    /// Executes the query and returns a result for the given transaction ID.
    pub(crate) async fn get(
        session: &CassandraSession, txn_id: DbTransactionId,
    ) -> Result<Option<Query>> {
        session
            .execute_iter(
                PreparedSelectQuery::CatalystIdByTransactionId,
                QueryParams { txn_id },
            )
            .await?
            .rows_stream::<Query>()?
            .next()
            .await
            .transpose()
            .context("Failed to get Catalyst ID by transaction ID query row")
    }
}
