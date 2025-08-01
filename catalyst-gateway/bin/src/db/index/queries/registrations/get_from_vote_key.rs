//! get stake addr from vote key
use std::sync::Arc;

use scylla::{
    client::{pager::TypedRowStream, session::Session},
    statement::prepared::PreparedStatement,
    DeserializeRow, SerializeRow,
};
use tracing::error;

use crate::db::index::{
    queries::{PreparedQueries, PreparedSelectQuery},
    session::CassandraSession,
};

/// Get stake addr from vote key query.
const GET_STAKE_ADDR_FROM_VOTE_KEY: &str = include_str!("../cql/get_stake_addr_w_vote_key.cql");

/// Get stake addr
#[derive(SerializeRow)]
pub(crate) struct GetStakeAddrFromVoteKeyParams {
    /// Vote key.
    pub vote_key: Vec<u8>,
}

impl GetStakeAddrFromVoteKeyParams {
    /// Create a new instance of [`GetStakeAddrFromVoteKeyParams`]
    pub(crate) fn new(vote_key: Vec<u8>) -> GetStakeAddrFromVoteKeyParams {
        Self { vote_key }
    }
}

/// Get stake addr from vote key query.
#[derive(DeserializeRow)]
pub(crate) struct GetStakeAddrFromVoteKeyQuery {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_public_key: Vec<u8>,
}

impl GetStakeAddrFromVoteKeyQuery {
    /// Prepares a get stake addr from vote key query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_STAKE_ADDR_FROM_VOTE_KEY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get stake addr from vote key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_STAKE_ADDR_FROM_VOTE_KEY}"))
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetStakeAddrFromVoteKeyParams,
    ) -> anyhow::Result<TypedRowStream<GetStakeAddrFromVoteKeyQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::StakeAddrFromVoteKey, params)
            .await?
            .rows_stream::<GetStakeAddrFromVoteKeyQuery>()?;

        Ok(iter)
    }
}
