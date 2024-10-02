//! Get TXI by Transaction hash query

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

/// Get invalid registrations from stake addr query.
const GET_INVALID_REGISTRATIONS_FROM_STAKE_ADDR_QUERY: &str =
    include_str!("../cql/get_invalid_registration_w_stake_addr.cql");

/// Get registration
#[derive(SerializeRow)]
pub(crate) struct GetInvalidRegistrationParams {
    /// Stake address.
    pub stake_address: Vec<u8>,
}

impl GetInvalidRegistrationParams {
    /// Create a new instance of [`GetInvalidRegistrationParams`]
    pub(crate) fn new(stake_addr: Vec<u8>) -> GetInvalidRegistrationParams {
        Self {
            stake_address: stake_addr,
        }
    }
}

/// Get invalid registrations given stake addr
#[allow(clippy::expect_used)]
mod result {
    use scylla::FromRow;

    /// Get registration query result.
    #[derive(FromRow)]
    pub(crate) struct GetInvalidRegistrationQuery {
        /// Error report
        pub error_report: Vec<String>,
    }
}
/// Get invalid registration query.
pub(crate) struct GetInvalidRegistrationQuery;

impl GetInvalidRegistrationQuery {
    /// Prepares a get invalid registration query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_invalid_registration_query = PreparedQueries::prepare(
            session,
            GET_INVALID_REGISTRATIONS_FROM_STAKE_ADDR_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_invalid_registration_query {
            error!(error=%error, "Failed to prepare get registration query.");
        };

        get_invalid_registration_query
    }

    /// Executes get invalid registration info for given stake addr query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetInvalidRegistrationParams,
    ) -> anyhow::Result<TypedRowIterator<result::GetInvalidRegistrationQuery>> {
        let iter = session
            .execute_iter(
                PreparedSelectQuery::InvalidRegistrationsFromStakeAddr,
                params,
            )
            .await?
            .into_typed::<result::GetInvalidRegistrationQuery>();

        Ok(iter)
    }
}
