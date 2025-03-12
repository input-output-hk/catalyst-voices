//! Get invalid registrations for stake addr after given slot no.

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
    types::{DbSlot, DbTxnIndex},
};

/// Get invalid registrations from stake public key query.
const GET_INVALID_REGISTRATIONS_FROM_STAKE_PK_QUERY: &str =
    include_str!("../cql/get_invalid_registration_w_stake_pk.cql");

/// Get registration
#[derive(SerializeRow)]
pub(crate) struct GetInvalidRegistrationParams {
    /// Stake public key.
    stake_public_key: Vec<u8>,
    /// Block Slot Number.
    slot_no: DbSlot,
}

impl GetInvalidRegistrationParams {
    /// Create a new instance of [`GetInvalidRegistrationParams`]
    pub(crate) fn new<T: Into<DbSlot>>(
        stake_public_key: Vec<u8>, slot_no: T,
    ) -> GetInvalidRegistrationParams {
        Self {
            stake_public_key,
            slot_no: slot_no.into(),
        }
    }
}

/// Get invalid registrations given stake address.
#[derive(DeserializeRow)]
pub(crate) struct GetInvalidRegistrationQuery {
    /// Nonce value after normalization.
    pub nonce: num_bigint::BigInt,
    /// Raw Nonce value.
    pub raw_nonce: num_bigint::BigInt,
    /// Slot Number the invalid CIP 36 registration is in.
    pub slot_no: DbSlot,
    /// Transaction Index.
    pub txn_index: DbTxnIndex,
    /// Error report
    pub problem_report: String,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_public_key: Vec<u8>,
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
            GET_INVALID_REGISTRATIONS_FROM_STAKE_PK_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare get invalid registration from stake address query."))
        .map_err(|error| {
            anyhow::anyhow!("{error}\n--\n{GET_INVALID_REGISTRATIONS_FROM_STAKE_PK_QUERY}")
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
