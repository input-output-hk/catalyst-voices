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

/// Get all (`stake_addr,vote` keys)
/// [(`stake_addr,vote_key`)]
const GET_ALL_WITH_STAKES_AND_VOTE_KEYS: &str = include_str!("../cql/get_all_stake_addrs.cql");

/// Get registration
#[derive(SerializeRow)]
pub(crate) struct GetAllStakesAndVoteKeysParams {}

/// Get registration query.
#[derive(DeserializeRow)]
pub(crate) struct GetAllStakesAndVoteKeysQuery {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_address: Vec<u8>,
    /// Voting Public Key
    pub vote_key: Vec<u8>,
}

impl GetAllStakesAndVoteKeysQuery {
    /// Prepares get all `stake_addr` paired with vote keys [(`stake_addr,vote_key`)]
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_all_stake_and_vote_keys = PreparedQueries::prepare(
            session,
            GET_ALL_WITH_STAKES_AND_VOTE_KEYS,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_all_stake_and_vote_keys {
            error!(error=%error, "Failed to prepare get all (stake addrs, vote_keys)");
        };

        get_all_stake_and_vote_keys
    }

    /// Executes get all `stake_addr` paired with vote keys [(`stake_addr,vote_key`)]
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetAllStakesAndVoteKeysParams,
    ) -> anyhow::Result<TypedRowStream<GetAllStakesAndVoteKeysQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::GetAllStakesAndVoteKeys, params)
            .await?
            .rows_stream::<GetAllStakesAndVoteKeysQuery>()?;

        Ok(iter)
    }
}
