//! Get stake address by Catalyst ID.

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
    types::{DbCatalystId, DbStakeAddress},
};

/// Get stake address from cat id
const QUERY: &str = include_str!("../cql/get_stake_address_from_cat_id.cql");

/// Get stake address by Catalyst ID query params.
#[derive(SerializeRow)]
pub(crate) struct GetStakeAddressByCatIDParams {
    /// A Catalyst ID.
    pub catalyst_id: DbCatalystId,
}

impl GetStakeAddressByCatIDParams {
    /// Creates a new [`GetStakeAddressByCatIDParams`].
    pub(crate) fn new(catalyst_id: DbCatalystId) -> Self {
        Self { catalyst_id }
    }
}

/// Get Catalyst ID by stake address query.
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct GetStakeAddressByCatIDQuery {
    /// Stake address from Catalyst ID for.
    pub(crate) stake_address: DbStakeAddress,
}

impl GetStakeAddressByCatIDQuery {
    /// Prepares a get Catalyst ID by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(|e| error!(error=%e, "Failed to prepare get stake address by Catalyst ID"))
    }

    /// Executes a get stake address by Catalyst ID query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetStakeAddressByCatIDParams,
    ) -> anyhow::Result<TypedRowStream<GetStakeAddressByCatIDQuery>> {
        session
            .execute_iter(PreparedSelectQuery::StakeAddressByCatalystId, params)
            .await?
            .rows_stream::<GetStakeAddressByCatIDQuery>()
            .map_err(Into::into)
    }
}
