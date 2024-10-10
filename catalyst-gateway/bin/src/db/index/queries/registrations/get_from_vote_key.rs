//! get stake addr from vote key
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

/// Get stake addr given vote key
#[allow(clippy::expect_used)]
mod result {
    use scylla::FromRow;

    /// Get stake addr from vote key query result.
    #[derive(FromRow)]
    pub(crate) struct GetStakeAddrFromVoteKeyQuery {
        /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
        pub stake_address: Vec<u8>,
    }
}
/// Get stake addr from vote key query.
pub(crate) struct GetStakeAddrFromVoteKeyQuery;

impl GetStakeAddrFromVoteKeyQuery {
    /// Prepares a get stake addr from vote key query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_stake_addr_query = PreparedQueries::prepare(
            session,
            GET_STAKE_ADDR_FROM_VOTE_KEY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_stake_addr_query {
            error!(error=%error, "Failed to prepare get stake addr from vote key query.");
        };

        get_stake_addr_query
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetStakeAddrFromVoteKeyParams,
    ) -> anyhow::Result<TypedRowIterator<result::GetStakeAddrFromVoteKeyQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::StakeAddrFromVoteKey, params)
            .await?
            .into_typed::<result::GetStakeAddrFromVoteKeyQuery>();

        Ok(iter)
    }
}
