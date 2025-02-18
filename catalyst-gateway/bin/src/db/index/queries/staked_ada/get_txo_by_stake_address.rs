//! Get the TXO by Stake Address
use std::sync::Arc;

use cardano_blockchain_types::Slot;
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
    types::{DbSlot, DbTransactionHash, DbTxnIndex, DbTxnOutputOffset},
};

/// Get txo by stake address query string.
const GET_TXO_BY_STAKE_ADDRESS_QUERY: &str = include_str!("../cql/get_txo_by_stake_address.cql");

/// Get txo by stake address query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetTxoByStakeAddressQueryParams {
    /// Stake address.
    stake_address: Vec<u8>,
    /// Max slot num.
    slot_no: DbSlot,
}

impl GetTxoByStakeAddressQueryParams {
    /// Creates a new [`GetTxoByStakeAddressQueryParams`].
    pub(crate) fn new(stake_address: Vec<u8>, slot_no: Slot) -> Self {
        Self {
            stake_address,
            slot_no: slot_no.into(),
        }
    }
}

/// Get txo by stake address query.
#[derive(DeserializeRow)]
pub(crate) struct GetTxoByStakeAddressQuery {
    /// TXO transaction hash.
    pub txn_id: DbTransactionHash,
    /// TXO transaction index within the slot.
    pub txn_index: DbTxnIndex,
    /// TXO index.
    pub txo: DbTxnOutputOffset,
    /// TXO transaction slot number.
    pub slot_no: DbSlot,
    /// TXO value.
    pub value: num_bigint::BigInt,
    /// TXO spent slot.
    pub spent_slot: Option<DbSlot>,
}

impl GetTxoByStakeAddressQuery {
    /// Prepares a get txo by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_TXO_BY_STAKE_ADDRESS_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare get TXO by stake address."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_TXO_BY_STAKE_ADDRESS_QUERY}"))
    }

    /// Executes a get txo by stake address query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetTxoByStakeAddressQueryParams,
    ) -> anyhow::Result<TypedRowStream<GetTxoByStakeAddressQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::TxoByStakeAddress, params)
            .await?
            .rows_stream::<GetTxoByStakeAddressQuery>()?;

        Ok(iter)
    }
}
