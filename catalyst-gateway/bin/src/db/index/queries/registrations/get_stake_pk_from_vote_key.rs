//! get stake public key from vote public key.

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

/// Get stake public key from vote key query.
const GET_STAKE_PK_FROM_VOTE_KEY: &str = include_str!("../cql/get_stake_pk_w_vote_key.cql");

/// Get stake public key.
#[derive(SerializeRow)]
pub(crate) struct GetStakePublicKeyFromVoteKeyParams {
    /// Vote public key.
    pub vote_key: Vec<u8>,
}

impl GetStakePublicKeyFromVoteKeyParams {
    /// Create a new instance of [`GetStakePublicKeyFromVoteKeyParams`]
    pub(crate) fn new(vote_key: Vec<u8>) -> GetStakePublicKeyFromVoteKeyParams {
        Self { vote_key }
    }
}

/// Get stake public key from vote key query.
#[derive(DeserializeRow)]
#[allow(dead_code)]
pub(crate) struct GetStakePublicKeyFromVoteKeyQuery {
    /// Stake public key - 32 bytes ED25519 Public key).
    pub stake_public_key: Vec<u8>,
}

impl GetStakePublicKeyFromVoteKeyQuery {
    /// Prepares a get stake public key from vote key query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_STAKE_PK_FROM_VOTE_KEY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get stake public key from vote key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_STAKE_PK_FROM_VOTE_KEY}"))
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetStakePublicKeyFromVoteKeyParams,
    ) -> anyhow::Result<TypedRowStream<GetStakePublicKeyFromVoteKeyQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::StakePublicKeyFromVoteKey, params)
            .await?
            .rows_stream::<GetStakePublicKeyFromVoteKeyQuery>()?;

        Ok(iter)
    }
}
