//! Get registrations by chain root.
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
    types::DbCatalystId,
};

/// Get get chain root by stake address query string.
const GET_REGISTRATIONS_BY_CHAIN_ROOT_CQL: &str =
    include_str!("../cql/get_registrations_by_chain_root.cql");

/// Get chain root by stake address query params.
#[derive(SerializeRow)]
pub(crate) struct GetRegistrationsByChainRootQueryParams {
    /// Chain root to get registrations for.
    pub(crate) catalyst_id: DbCatalystId,
}

/// Get chain root by stake address query.
#[derive(DeserializeRow)]
pub(crate) struct GetRegistrationsByChainRootQuery {
    /// Registration transaction id.
    pub(crate) transaction_id: Vec<u8>,
}

impl GetRegistrationsByChainRootQuery {
    /// Prepares a get registrations by chain root query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_registrations_by_chain_root_query = PreparedQueries::prepare(
            session,
            GET_REGISTRATIONS_BY_CHAIN_ROOT_CQL,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_registrations_by_chain_root_query {
            error!(error=%error, "Failed to prepare get registrations by chain root query");
        };

        get_registrations_by_chain_root_query
    }

    /// Executes a get registrations by chain root query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetRegistrationsByChainRootQueryParams,
    ) -> anyhow::Result<TypedRowStream<GetRegistrationsByChainRootQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::RegistrationsByChainRoot, params)
            .await?
            .rows_stream::<GetRegistrationsByChainRootQuery>()?;

        Ok(iter)
    }
}
