//! Get chain root by stake address.
use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, DeserializeRow,
    SerializeRow, Session,
};
use tracing::error;

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::{DbSlot, DbTransactionHash, DbTxnIndex},
};

/// Get get chain root by stake address query string.
const GET_CHAIN_ROOT: &str = include_str!("../cql/get_chain_root_for_transaction_id.cql");

/// Get chain root by stake address query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// Transaction ID to look up.
    pub(crate) transaction_id: DbTransactionHash,
}

/// Get chain root by stake address query.
#[derive(DeserializeRow)]
pub(crate) struct Query {
    /// Chain root for the queries stake address.
    pub(crate) chain_root: DbTransactionHash,
    /// Slot Number the cert is in.
    pub(crate) slot_no: DbSlot,
    /// Transaction Index.
    pub(crate) txn: DbTxnIndex,
}

impl Query {
    /// Prepares a get chain root by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_chain_root_by_stake_address_query = PreparedQueries::prepare(
            session,
            GET_CHAIN_ROOT,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_chain_root_by_stake_address_query {
            error!(error=%error, "Failed to prepare get chain root by stake address query");
        };

        get_chain_root_by_stake_address_query
    }

    /// Executes a get chain root by stake address query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> anyhow::Result<TypedRowStream<Query>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::ChainRootByStakeAddress, params)
            .await?
            .rows_stream::<Query>()?;

        Ok(iter)
    }
}
