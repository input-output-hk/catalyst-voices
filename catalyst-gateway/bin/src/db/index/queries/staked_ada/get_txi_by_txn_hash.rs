//! Get TXI by Transaction hash query

use std::{fmt, sync::Arc};

use cardano_blockchain_types::TransactionId;
use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, DeserializeRow,
    SerializeRow, Session,
};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{PreparedQueries, PreparedSelectQuery, Query, QueryKind},
            session::CassandraSession,
        },
        types::{DbSlot, DbTransactionId, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

/// Get TXI query string.
const GET_TXI_BY_TXN_HASHES_QUERY: &str = include_str!("../cql/get_txi_by_txn_ids.cql");

/// Get TXI query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetTxiByTxnHashesQueryParams {
    /// Transaction hashes.
    txn_ids: Vec<DbTransactionId>,
}

impl GetTxiByTxnHashesQueryParams {
    /// Create a new instance of [`GetTxiByTxnHashesQueryParams`]
    pub(crate) fn new(txn_ids: Vec<TransactionId>) -> Self {
        let txn_ids = txn_ids.into_iter().map(Into::into).collect();
        Self { txn_ids }
    }
}

/// Get TXI query.
#[derive(DeserializeRow)]
pub(crate) struct GetTxiByTxnHashesQuery {
    /// TXI transaction hash.
    pub txn_id: DbTransactionId,
    /// TXI original TXO index.
    pub txo: DbTxnOutputOffset,
    /// TXI slot number.
    pub slot_no: DbSlot,
}

impl Query for GetTxiByTxnHashesQuery {
    /// Prepare Batch of Insert TXI Index Data Queries
    async fn prepare_query(
        session: &Arc<Session>, _cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<QueryKind> {
        Self::prepare(session).await.map(QueryKind::Statement)
    }
}

impl fmt::Display for GetTxiByTxnHashesQuery {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{GET_TXI_BY_TXN_HASHES_QUERY}")
    }
}

impl GetTxiByTxnHashesQuery {
    /// Prepares a get txi query.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            GET_TXI_BY_TXN_HASHES_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare get TXI by txn hashes query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_TXI_BY_TXN_HASHES_QUERY}"))
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetTxiByTxnHashesQueryParams,
    ) -> anyhow::Result<TypedRowStream<GetTxiByTxnHashesQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::TxiByTransactionHash, params)
            .await?
            .rows_stream::<GetTxiByTxnHashesQuery>()?;

        Ok(iter)
    }
}
