//! Get chain root by stake address.
use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, SerializeRow,
    Session,
};
use tracing::error;

use crate::db::index::{
    queries::{PreparedQueries, PreparedSelectQuery},
    session::CassandraSession,
};

/// Get get chain root by stake address query string.
const GET_CHAIN_ROOT: &str = include_str!("../cql/get_chain_root.cql");

/// Get chain root by stake address query params.
#[derive(SerializeRow)]
pub(crate) struct GetChainRootQueryParams {
    /// Stake address to get the chain root for.
    pub(crate) stake_address: Vec<u8>,
}

/// Get chain root by stake address query row result
// The macro uses expect to signal an error in deserializing values.
mod result {
    use scylla::DeserializeRow;

    /// Get chain root query result.
    #[derive(DeserializeRow)]
    pub(crate) struct GetChainRootQuery {
        /// Chain root for the queries stake address.
        pub(crate) chain_root: Vec<u8>,
    }
}

/// Get chain root by stake address query.
pub(crate) struct GetChainRootQuery;

impl GetChainRootQuery {
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
        session: &CassandraSession, params: GetChainRootQueryParams,
    ) -> anyhow::Result<TypedRowStream<result::GetChainRootQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::ChainRootByStakeAddress, params)
            .await?
            .rows_stream::<result::GetChainRootQuery>()?;

        Ok(iter)
    }
}
