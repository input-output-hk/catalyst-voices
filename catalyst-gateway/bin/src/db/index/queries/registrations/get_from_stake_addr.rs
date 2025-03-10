//! Get stake addr registrations

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

/// Get registrations from stake addr query.
const GET_REGISTRATIONS_FROM_STAKE_ADDR_QUERY: &str =
    include_str!("../cql/get_registrations_w_stake_addr.cql");

/// Get registration
#[derive(SerializeRow)]
pub(crate) struct GetRegistrationParams {
    /// Stake address.
    stake_public_key: Vec<u8>,
    /// Block Slot Number.
    slot_no: DbSlot,
}

impl GetRegistrationParams {
    /// Create a new instance of [`GetRegistrationParams`]
    pub(crate) fn new<T: Into<DbSlot>>(stake_public_key: Vec<u8>, slot_no: T) -> Self {
        Self {
            stake_public_key,
            slot_no: slot_no.into(),
        }
    }
}

/// Get registration query.
#[derive(DeserializeRow)]
pub(crate) struct GetRegistrationQuery {
    /// Nonce value after normalization.
    pub nonce: num_bigint::BigInt,
    /// Slot Number the cert is in.
    pub slot_no: DbSlot,
    /// Transaction Index.
    pub txn_index: DbTxnIndex,
    /// Voting Public Key
    pub vote_key: Vec<u8>,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    pub payment_address: Vec<u8>,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

impl GetRegistrationQuery {
    /// Prepares a get registration query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_REGISTRATIONS_FROM_STAKE_ADDR_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare get registration from stake address query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_REGISTRATIONS_FROM_STAKE_ADDR_QUERY}"))
    }

    /// Executes get registration info for given stake addr query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetRegistrationParams,
    ) -> anyhow::Result<TypedRowStream<GetRegistrationQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::RegistrationFromStakeAddr, params)
            .await?
            .rows_stream::<GetRegistrationQuery>()?;

        Ok(iter)
    }
}
