//! Get TXI by Transaction hash query

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

/// Get latest registration query string.
const GET_STAKE_ADDR_FROM_STAKE_HASH: &str =
    include_str!("../cql/get_stake_addr_w_stake_key_hash.cql");

/// Get stake addr
#[derive(SerializeRow)]
pub(crate) struct GetStakeAddrParams {
    /// Stake hash.
    pub stake_hash: Vec<u8>,
}

impl GetStakeAddrParams {
    /// Create a new instance of [`GetStakeAddrParams`]
    pub(crate) fn new(stake_hash: Vec<u8>) -> GetStakeAddrParams {
        Self { stake_hash }
    }
}

/// Get latest registration given stake addr or vote key
#[allow(clippy::expect_used)]
mod result {
    use scylla::FromRow;

    /// Get Latest registration query result.
    #[derive(FromRow)]
    pub(crate) struct GetStakeAddrQuery {
        /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
        pub stake_address: Vec<u8>,
    }
}
/// Get latest registration query.
pub(crate) struct GetStakeAddrQuery;

impl GetStakeAddrQuery {
    /// Prepares a get txi query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_stake_addr_query = PreparedQueries::prepare(
            session,
            GET_STAKE_ADDR_FROM_STAKE_HASH,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_stake_addr_query {
            error!(error=%error, "Failed to prepare get stake addr query.");
        };

        get_stake_addr_query
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetStakeAddrParams,
    ) -> anyhow::Result<TypedRowIterator<result::GetStakeAddrQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::StakeAddrFromStakeHash, params)
            .await?
            .into_typed::<result::GetStakeAddrQuery>();

        Ok(iter)
    }
}