//! Get invalid registrations for stake addr after given slot no.

use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, DeserializeRow,
    SerializeRow, Session,
};
use tracing::error;

use crate::{
    db::index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    service::common::types::cardano::slot_no::SlotNo,
};

/// Get invalid registrations from stake addr query.
const GET_INVALID_REGISTRATIONS_FROM_STAKE_ADDR_QUERY: &str =
    include_str!("../cql/get_invalid_registration_w_stake_addr.cql");

/// Get registration
#[derive(SerializeRow)]
pub(crate) struct GetInvalidRegistrationParams {
    /// Stake address.
    pub stake_address: Vec<u8>,
    /// Block Slot Number when spend occurred.
    slot_no: num_bigint::BigInt,
}

impl GetInvalidRegistrationParams {
    /// Create a new instance of [`GetInvalidRegistrationParams`]
    pub(crate) fn new(stake_address: Vec<u8>, slot_no: SlotNo) -> GetInvalidRegistrationParams {
        Self {
            stake_address,
            slot_no: slot_no.into(),
        }
    }
}

/// Get invalid registrations given stake address.
#[derive(DeserializeRow)]
pub(crate) struct GetInvalidRegistrationQuery {
    /// Error report
    pub error_report: String,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_address: Vec<u8>,
    /// Voting Public Key
    pub vote_key: Vec<u8>,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    pub payment_address: Vec<u8>,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

impl GetInvalidRegistrationQuery {
    /// Prepares a get invalid registration query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_INVALID_REGISTRATIONS_FROM_STAKE_ADDR_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare get invalid registration from stake address query."))
        .map_err(|error| {
            anyhow::anyhow!("{error}\n--\n{GET_INVALID_REGISTRATIONS_FROM_STAKE_ADDR_QUERY}")
        })
    }

    /// Executes get invalid registration info for given stake addr query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetInvalidRegistrationParams,
    ) -> anyhow::Result<TypedRowStream<GetInvalidRegistrationQuery>> {
        let iter = session
            .execute_iter(
                PreparedSelectQuery::InvalidRegistrationsFromStakeAddr,
                params,
            )
            .await?
            .rows_stream::<GetInvalidRegistrationQuery>()?;

        Ok(iter)
    }
}
