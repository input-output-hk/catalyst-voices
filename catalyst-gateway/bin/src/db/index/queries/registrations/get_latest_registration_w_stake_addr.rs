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

/// Get TXI query string.
const GET_LATEST_REGISTRATION_QUERY: &str =
    include_str!("../cql/get_latest_registration_w_stake_addr.cql");

/// Get TXI query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetLatestRegistration {
    /// Transaction hashes.
    txn_hashes: Vec<Vec<u8>>,
}

impl GetLatestRegistration {
    /// Create a new instance of [`GetTxiByTxnHashesQueryParams`]
    pub(crate) fn new(txn_hashes: Vec<Vec<u8>>) -> Self {
        Self { txn_hashes }
    }
}

/// Get TXI Query Result
// TODO: https://github.com/input-output-hk/catalyst-voices/issues/828
// The macro uses expect to signal an error in deserializing values.
#[allow(clippy::expect_used)]
mod result {
    use scylla::FromRow;

    /// Get TXI query result.
    #[derive(FromRow)]
    pub(crate) struct GetLatestRegistrationQuery {
        /// TXI transaction hash.
        pub txn_hash: Vec<u8>,
        /// TXI original TXO index.
        pub txo: i16,
        /// TXI slot number.
        pub slot_no: num_bigint::BigInt,
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
        session: &CassandraSession, params: GetLatestRegistration,
    ) -> anyhow::Result<TypedRowIterator<result::GetLatestRegistrationQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::GetLatestRegistration, params)
            .await?
            .into_typed::<result::GetLatestRegistrationQuery>();

        Ok(iter)
    }
}
