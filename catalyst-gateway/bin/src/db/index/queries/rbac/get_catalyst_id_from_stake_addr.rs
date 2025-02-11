//! Get Catalyst ID by stake address.

use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, statement::Consistency,
    transport::iterator::TypedRowStream, DeserializeRow, SerializeRow, Session,
};
use tracing::error;

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::{DbCatalystId, DbCip19StakeAddress, DbSlot, DbTxnIndex},
};

/// Get Catalyst ID by stake address query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_stake_addr.cql");

/// Get Catalyst ID by stake address query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// Stake address to get the Catalyst ID for.
    pub(crate) stake_address: DbCip19StakeAddress,
}

/// Get Catalyst ID by stake address query.
// TODO: Remove the `dead_code` annotation when the query is used.
#[allow(dead_code)]
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct Query {
    /// Slot Number the stake address was registered in.
    pub slot_no: DbSlot,
    /// Transaction Offset the stake address was registered in.
    pub txn: DbTxnIndex,
    /// Catalyst ID for the queries stake address.
    pub catalyst_id: DbCatalystId,
}

impl Query {
    /// Prepares a get Catalyst ID by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get Catalyst ID by stake address query"),
            )
    }

    /// Executes a get Catalyst ID by stake address query.
    // TODO: Remove the `dead_code` annotation when the query is used.
    #[allow(dead_code)]
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> anyhow::Result<TypedRowStream<Query>> {
        session
            .execute_iter(PreparedSelectQuery::CatalystIdByStakeAddress, params)
            .await?
            .rows_stream::<Query>()
            .map_err(Into::into)
    }
}
