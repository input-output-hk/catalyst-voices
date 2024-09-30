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
    pub stake_address: Vec<u8>,
}

impl GetLatestRegistrationParams {
    /// Create a new instance of [`GetLatestRegistrationParams`]
    pub(crate) fn new(stake_addr: Vec<u8>) -> GetLatestRegistrationParams {
        Self {
            stake_address: stake_addr,
        }
    }
}

/// Get latest registration given stake addr or vote key
#[allow(clippy::expect_used)]
mod result {
    use scylla::FromRow;

    /// Get Latest registration query result.
    #[derive(FromRow)]
    pub(crate) struct GetLatestRegistrationQuery {
        /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
        pub stake_address: Vec<u8>,
        /// Nonce value after normalization.
        pub nonce: num_bigint::BigInt,
        /// Slot Number the cert is in.
        pub slot_no: num_bigint::BigInt,
        /// Transaction Index.
        pub txn: i16,
        /// Voting Public Key
        pub vote_key: Vec<u8>,
        /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
        pub payment_address: Vec<u8>,
        /// Is the stake address a script or not.
        pub is_payable: bool,
        /// Is the Registration CIP36 format, or CIP15
        pub cip36: bool,
    }
}
/// Get latest registration query.
pub(crate) struct GetLatestRegistrationQuery;

impl GetLatestRegistrationQuery {
    /// Prepares a get latest registration query.
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
            .execute_iter(PreparedSelectQuery::LatestRegistration, params)
            .await?
            .into_typed::<result::GetLatestRegistrationQuery>();

        Ok(iter)
    }
}
