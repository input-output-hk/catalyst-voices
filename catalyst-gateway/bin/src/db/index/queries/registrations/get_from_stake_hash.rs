//! Get stake addr from stake hash

use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, SerializeRow,
    Session,
};
use tracing::error;

use crate::db::index::{
    queries::{PreparedQueries, PreparedSelectQuery},
    session::CassandraSession,
};

/// Get stake addr from stake hash query string.
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

/// Get stake addr from stake hash query string.
#[allow(clippy::expect_used)]
mod result {
    use scylla::DeserializeRow;

    /// Get stake addr from stake hash query result.
    #[derive(DeserializeRow)]
    pub(crate) struct GetStakeAddrQuery {
        /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
        pub stake_address: Vec<u8>,
    }
}
/// Get registration query.
pub(crate) struct GetStakeAddrQuery;

impl GetStakeAddrQuery {
    /// Prepares a get get stake addr from stake hash query.
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
    ) -> anyhow::Result<TypedRowStream<result::GetStakeAddrQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::StakeAddrFromStakeHash, params)
            .await?
            .rows_stream::<result::GetStakeAddrQuery>()?;

        Ok(iter)
    }
}
