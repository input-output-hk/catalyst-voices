//! Get all registrations for snapshot

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

/// Get all registrations
const GET_ALL_REGISTRATIONS: &str = include_str!("../cql/get_all_registrations.cql");

/// Get all registrations
#[derive(SerializeRow)]
pub(crate) struct GetAllRegistrationsParams {}

/// Get all registration details for snapshot.
#[derive(DeserializeRow)]
pub(crate) struct GetAllRegistrationsQuery {
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

impl GetAllRegistrationsQuery {
    /// Prepares get all registrations
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_ALL_REGISTRATIONS,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare get all registrations"))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_ALL_REGISTRATIONS}"))
    }

    /// Executes get all registrations for snapshot
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetAllRegistrationsParams,
    ) -> anyhow::Result<TypedRowStream<GetAllRegistrationsQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::GetAllRegistrations, params)
            .await?
            .rows_stream::<GetAllRegistrationsQuery>()?;

        Ok(iter)
    }
}
