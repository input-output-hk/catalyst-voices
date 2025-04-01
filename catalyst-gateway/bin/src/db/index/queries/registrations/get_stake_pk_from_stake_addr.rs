//! Get stake public key from stake address.

use std::sync::Arc;

use cardano_blockchain_types::StakeAddress;
use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, DeserializeRow,
    SerializeRow, Session,
};
use tracing::error;

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::DbStakeAddress,
};

/// Get stake public key from stake address query string.
const GET_QUERY: &str = include_str!("../cql/get_stake_pk_w_stake_addr.cql");

/// Get stake public key from stake address parameters
#[derive(SerializeRow)]
pub(crate) struct GetStakePublicKeyFromStakeAddrParams {
    /// Stake address.
    pub stake_address: DbStakeAddress,
}

impl GetStakePublicKeyFromStakeAddrParams {
    /// Create a new instance of [`GetStakePublicKeyFromStakeAddrParams`]
    pub(crate) fn new(stake_address: StakeAddress) -> GetStakePublicKeyFromStakeAddrParams {
        Self {
            stake_address: stake_address.into(),
        }
    }
}

/// Get stake public key from stake address query.
#[derive(DeserializeRow)]
pub(crate) struct GetStakePublicKeyFromStakeAddrQuery {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_public_key: Vec<u8>,
}

impl GetStakePublicKeyFromStakeAddrQuery {
    /// Prepares a get get stake public key from stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get stake public key from stake address query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_QUERY}"))
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
