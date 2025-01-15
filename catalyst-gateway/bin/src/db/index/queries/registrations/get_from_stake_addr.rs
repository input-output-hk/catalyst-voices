//! Get stake addr registrations

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

/// Get registrations from stake addr query.
const GET_REGISTRATIONS_FROM_STAKE_ADDR_QUERY: &str =
    include_str!("../cql/get_registrations_w_stake_addr.cql");

/// Get registration
#[derive(SerializeRow)]
pub(crate) struct GetRegistrationParams {
    /// Stake address.
    pub stake_address: Vec<u8>,
}

impl From<Vec<u8>> for GetRegistrationParams {
    fn from(value: Vec<u8>) -> Self {
        GetRegistrationParams {
            stake_address: value,
        }
    }
}

/// Get registration query.
#[derive(DeserializeRow)]
pub(crate) struct GetRegistrationQuery {
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

impl GetRegistrationQuery {
    /// Prepares a get registration query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_registrations_query = PreparedQueries::prepare(
            session,
            GET_REGISTRATIONS_FROM_STAKE_ADDR_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_registrations_query {
            error!(error=%error, "Failed to prepare get registration query.");
        };

        get_registrations_query
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
