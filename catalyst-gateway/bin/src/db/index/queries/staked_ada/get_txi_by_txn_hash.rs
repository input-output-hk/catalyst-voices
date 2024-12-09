//! Get TXI by Transaction hash query

use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, DeserializeRow,
    SerializeRow, Session,
};
use tracing::error;

use crate::db::index::{
    queries::{PreparedQueries, PreparedSelectQuery},
    session::CassandraSession,
};

/// Get TXI query string.
const GET_TXI_BY_TXN_HASHES_QUERY: &str = include_str!("../cql/get_txi_by_txn_hashes.cql");

/// Get TXI query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetTxiByTxnHashesQueryParams {
    /// Transaction hashes.
    txn_hashes: Vec<Vec<u8>>,
}

impl GetTxiByTxnHashesQueryParams {
    /// Create a new instance of [`GetTxiByTxnHashesQueryParams`]
    pub(crate) fn new(txn_hashes: Vec<Vec<u8>>) -> Self {
        Self { txn_hashes }
    }
}

/// Get TXI query.
#[derive(DeserializeRow)]
pub(crate) struct GetTxiByTxnHashesQuery {
    /// TXI transaction hash.
    pub txn_hash: Vec<u8>,
    /// TXI original TXO index.
    pub txo: i16,
    /// TXI slot number.
    pub slot_no: num_bigint::BigInt,
}

impl GetTxiByTxnHashesQuery {
    /// Prepares a get txi query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_txi_by_txn_hashes_query = PreparedQueries::prepare(
            session,
            GET_TXI_BY_TXN_HASHES_QUERY,
            scylla::statement::Consistency::LocalQuorum,
            true,
        )
        .await;

        if let Err(ref error) = get_txi_by_txn_hashes_query {
            error!(error=%error, "Failed to prepare get TXI by txn hashes query.");
        };

        get_txi_by_txn_hashes_query
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
