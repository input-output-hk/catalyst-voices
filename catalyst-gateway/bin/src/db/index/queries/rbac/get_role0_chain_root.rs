//! Get chain root by role0 key.
use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowIterator, SerializeRow,
    Session,
};
use tracing::error;

use crate::db::index::{
    queries::{PreparedQueries, PreparedSelectQuery},
    session::CassandraSession,
};

/// Get chain root by role0 key query string.
const GET_ROLE0_KEY_CHAIN_ROOT_CQL: &str = include_str!("../cql/get_role0_key_chain_root.cql");

/// Get chain root by role0 key query params.
#[derive(SerializeRow)]
pub(crate) struct GetRole0ChainRootQueryParams {
    /// Role0 key to get the chain root for.
    pub(crate) role0_key: Vec<u8>,
}

/// Get chain root by role0 key query row result
// TODO: https://github.com/input-output-hk/catalyst-voices/issues/828
// The macro uses expect to signal an error in deserializing values.
#[allow(clippy::expect_used)]
mod result {
    use scylla::FromRow;

    /// Get role0 key chain root query result.
    #[derive(FromRow)]
    pub(crate) struct GetRole0ChainRootQuery {
        /// Chain root.
        pub(crate) chain_root: Vec<u8>,
    }
}

/// Get chain root by role0 key query.
pub(crate) struct GetRole0ChainRootQuery;

impl GetRole0ChainRootQuery {
    /// Prepares a get chain root by role0 key query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_chain_root_by_role0_key_query = PreparedQueries::prepare(
            session,
            GET_ROLE0_KEY_CHAIN_ROOT_CQL,
            scylla::statement::Consistency::LocalQuorum,
            true,
        )
        .await;

        if let Err(ref error) = get_chain_root_by_role0_key_query {
            error!(error=%error, "Failed to prepare get chain root by role0 key query");
        };

        get_chain_root_by_role0_key_query
    }

    /// Executes a get chain root role0 key query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetRole0ChainRootQueryParams,
    ) -> anyhow::Result<TypedRowIterator<result::GetRole0ChainRootQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::ChainRootByRole0Key, params)
            .await?
            .into_typed::<result::GetRole0ChainRootQuery>();

        Ok(iter)
    }
}
