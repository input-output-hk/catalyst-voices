//! Get stake addr from stake address

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
const GET_QUERY: &str = include_str!("../cql/get_stake_addr_w_stake_address.cql");

/// Get stake addr
#[derive(SerializeRow)]
pub(crate) struct GetStakeAddrParams {
    /// Stake hash.
    pub stake_address: Vec<u8>,
}

impl GetStakeAddrParams {
    /// Create a new instance of [`GetStakeAddrParams`]
    pub(crate) fn new(stake_address: Vec<u8>) -> GetStakeAddrParams {
        Self { stake_address }
    }
}

/// Get stake addr from stake hash query.
#[derive(DeserializeRow)]
pub(crate) struct GetStakeAddrQuery {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_public_key: Vec<u8>,
}

impl GetStakeAddrQuery {
    /// Prepares a get get stake addr from stake hash query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get stake addr from stake hash query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_QUERY}"))
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetStakeAddrParams,
    ) -> anyhow::Result<TypedRowStream<GetStakeAddrQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::StakeAddrFromStakeHash, params)
            .await?
            .rows_stream::<GetStakeAddrQuery>()?;

        Ok(iter)
    }
}
