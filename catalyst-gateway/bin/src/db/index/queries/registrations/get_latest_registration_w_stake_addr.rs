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

/// Get latest registration query string.
const GET_LATEST_REGISTRATION_QUERY: &str =
    include_str!("../cql/get_latest_registration_w_stake_addr.cql");

/// Get latest registration
#[derive(SerializeRow)]
pub(crate) struct GetLatestRegistrationParams {
    /// Stake address.
    stake_address: Vec<u8>,
}

impl GetLatestRegistrationParams {
    /// Create a new instance of [`GetLatestRegistrationParams`]
    pub(crate) fn new(stake_addr: Vec<u8>) -> GetLatestRegistrationParams {
        Self {
            stake_address: stake_addr,
        }
    }
}

/// A
#[allow(clippy::expect_used)]
#[allow(dead_code)]
mod result {
    use scylla::FromRow;

    /// Get TXI query result.
    #[derive(FromRow)]
    pub(crate) struct GetLatestRegistrationQuery {
        /// TXI slot number.
        pub stake_address: Vec<u8>,
    }
}
/// Get latest registration query.
pub(crate) struct GetLatestRegistrationQuery;

impl GetLatestRegistrationQuery {
    /// Prepares a get txi query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_latest_registration_query = PreparedQueries::prepare(
            session,
            GET_LATEST_REGISTRATION_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_latest_registration_query {
            error!(error=%error, "Failed to prepare get latest registration query.");
        };

        get_latest_registration_query
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetLatestRegistrationParams,
    ) -> anyhow::Result<TypedRowIterator<result::GetLatestRegistrationQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::GetLatestRegistration, params)
            .await?
            .into_typed::<result::GetLatestRegistrationQuery>();

        Ok(iter)
    }
}
