//! Get the TXO by Stake Address
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

/// Get txo by stake address query string.
const GET_TXO_BY_STAKE_ADDRESS_QUERY: &str = include_str!("../cql/get_txo_by_stake_address.cql");

/// Get txo by stake address query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetTxoByStakeAddressQueryParams {
    /// Stake address.
    stake_address: Vec<u8>,
    /// Max slot num.
    slot_no: num_bigint::BigInt,
}

impl GetTxoByStakeAddressQueryParams {
    /// Creates a new [`GetTxoByStakeAddressQueryParams`].
    pub(crate) fn new(stake_address: Vec<u8>, slot_no: num_bigint::BigInt) -> Self {
        Self {
            stake_address,
            slot_no,
        }
    }
}

/// Get TXO by stake address query row result
// TODO: https://github.com/input-output-hk/catalyst-voices/issues/828
// The macro uses expect to signal an error in deserializing values.
#[allow(clippy::expect_used)]
mod result {
    use scylla::FromRow;

    /// Get txo by stake address query result.
    #[derive(FromRow)]
    pub(crate) struct GetTxoByStakeAddressQuery {
        /// TXO transaction hash.
        pub txn_hash: Vec<u8>,
        /// TXO transaction index within the slot.
        pub txn: i16,
        /// TXO index.
        pub txo: i16,
        /// TXO transaction slot number.
        pub slot_no: num_bigint::BigInt,
        /// TXO value.
        pub value: num_bigint::BigInt,
        /// TXO spent slot.
        pub spent_slot: Option<num_bigint::BigInt>,
    }
}

/// Get staked ADA query.
pub(crate) struct GetTxoByStakeAddressQuery;

impl GetTxoByStakeAddressQuery {
    /// Prepares a get txo by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_txo_by_stake_address_query = PreparedQueries::prepare(
            session,
            GET_TXO_BY_STAKE_ADDRESS_QUERY,
            scylla::statement::Consistency::LocalQuorum,
            true,
        )
        .await;

        if let Err(ref error) = get_txo_by_stake_address_query {
            error!(error=%error, "Failed to prepare get TXO by stake address");
        };

        get_txo_by_stake_address_query
    }

    /// Executes a get txo by stake address query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetTxoByStakeAddressQueryParams,
    ) -> anyhow::Result<TypedRowIterator<result::GetTxoByStakeAddressQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::TxoByStakeAddress, params)
            .await?
            .into_typed::<result::GetTxoByStakeAddressQuery>();

        Ok(iter)
    }
}
