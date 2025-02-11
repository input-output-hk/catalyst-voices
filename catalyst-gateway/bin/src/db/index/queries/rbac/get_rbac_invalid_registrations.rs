//! Get invalid RBAC registrations by Catalyst ID.

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
    types::DbCatalystId,
};

/// Get invalid registrations by Catalyst ID query.
const QUERY: &str = include_str!("../cql/get_rbac_invalid_registrations_catalyst_id.cql");

/// Get invalid registrations by Catalyst ID query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// A Catalyst ID.
    pub catalyst_id: DbCatalystId,
}

/// Get invalid registrations by Catalyst ID query.
// TODO: Remove the `dead_code` annotation when the query is used.
#[allow(dead_code)]
#[derive(DeserializeRow)]
pub(crate) struct Query {
    /// Registration transaction id.
    pub transaction_id: Vec<u8>,
}

impl Query {
    /// Prepares a query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get registrations by Catalyst ID query"),
            )
    }

    /// Executes a get registrations by Catalyst ID query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> anyhow::Result<TypedRowStream<Query>> {
        session
            .execute_iter(
                PreparedSelectQuery::RbacInvalidRegistrationsByCatalystId,
                params,
            )
            .await?
            .rows_stream::<Query>()
            .map_err(Into::into)
    }
}
