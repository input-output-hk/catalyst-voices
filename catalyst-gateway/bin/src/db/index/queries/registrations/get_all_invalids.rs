//! Get all invalid registrations for snapshot

use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, DeserializeRow,
    SerializeRow, Session,
};
use tracing::error;

use crate::db::index::{
    queries::{PreparedQueries, PreparedSelectQuery},
    session::CassandraSession,
};

/// Get all invalid registrations
const GET_ALL_INVALIDS: &str = include_str!("../cql/get_all_invalids.cql");

/// Get all invalid registrations
#[derive(SerializeRow)]
pub(crate) struct GetAllInvalidRegistrationsParams {}

/// Get all invalid registrations details for snapshot.
#[derive(DeserializeRow)]
pub(crate) struct GetAllInvalidRegistrationsQuery {
    /// Error report
    pub error_report: Vec<String>,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_address: Vec<u8>,
    /// Slot Number
    pub slot_no: num_bigint::BigInt,
    /// Voting Public Key
    pub vote_key: Vec<u8>,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    pub payment_address: Vec<u8>,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

impl GetAllInvalidRegistrationsQuery {
    /// Prepares get all registrations
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_ALL_INVALIDS,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get all invalid registrations"),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_ALL_INVALIDS}"))
    }

    /// Executes get all registrations for snapshot
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetAllInvalidRegistrationsParams,
    ) -> anyhow::Result<TypedRowStream<GetAllInvalidRegistrationsQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::GetAllInvalidRegistrations, params)
            .await?
            .rows_stream::<GetAllInvalidRegistrationsQuery>()?;

        Ok(iter)
    }
}
