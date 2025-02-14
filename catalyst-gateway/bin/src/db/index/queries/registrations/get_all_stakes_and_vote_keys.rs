//! Get all stake and vote keys (`stake_pub_key,vote_key`)
//! Result is used to compose various query registrations for snapshot.

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
const GET_ALL_STAKES_AND_VOTE_KEYS: &str = include_str!("../cql/get_all_stake_addrs.cql");

/// Get all stake and vote keys from cip36 registration
#[derive(SerializeRow)]
pub(crate) struct GetAllStakesAndVoteKeysParams {}

/// Get stakes and vote keys for snapshot.
#[derive(DeserializeRow)]
pub(crate) struct GetAllStakesAndVoteKeysQuery {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_public_key: Vec<u8>,
    /// Voting Public Key
    pub vote_key: Vec<u8>,
}

impl GetAllStakesAndVoteKeysQuery {
    /// Prepares get all `stake_addr` paired with vote keys [(`stake_addr,vote_key`)]
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_ALL_STAKES_AND_VOTE_KEYS,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get all (stake addrs, vote_keys)"),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_ALL_STAKES_AND_VOTE_KEYS}"))
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
