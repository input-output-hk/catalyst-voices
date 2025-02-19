//! Get stake public key from stake address.

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

/// Get stake addr from stake hash query string.
const GET_STAKE_PK_FROM_STAKE_ADDR: &str = include_str!("../cql/get_stake_pk_w_stake_address.cql");

/// Get stake public key
#[derive(SerializeRow)]
pub(crate) struct GetStakePublicKeyFromStakeAddrParams {
    /// Stake address.
    pub stake_address: Vec<u8>,
}

impl GetStakePublicKeyFromStakeAddrParams {
    /// Create a new instance of [`GetStakePublicKeyFromStakeAddrParams`]
    pub(crate) fn new(stake_address: Vec<u8>) -> GetStakePublicKeyFromStakeAddrParams {
        Self { stake_address }
    }
}

/// Get stake public key from stake address query.
#[derive(DeserializeRow)]
pub(crate) struct GetStakePublicKeyFromStakeAddrQuery {
    /// Stake public key - 32 byte Ed25519 Public key, not hashed.
    pub stake_public_key: Vec<u8>,
}

impl GetStakePublicKeyFromStakeAddrQuery {
    /// Prepares a get get stake public key from stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_STAKE_PK_FROM_STAKE_ADDR,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get stake public key from stake address query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_STAKE_PK_FROM_STAKE_ADDR}"))
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetStakePublicKeyFromStakeAddrParams,
    ) -> anyhow::Result<TypedRowStream<GetStakePublicKeyFromStakeAddrQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::StakePublicKeyFromStakeAddr, params)
            .await?
            .rows_stream::<GetStakePublicKeyFromStakeAddrQuery>()?;

        Ok(iter)
    }
}
