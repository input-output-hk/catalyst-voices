//! Get assets by stake address.
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
    types::{DbSlot, DbTxnIndex, DbTxnOutputOffset},
};

/// Get assets by stake address query string.
const GET_ASSETS_BY_STAKE_ADDRESS_QUERY: &str =
    include_str!("../cql/get_assets_by_stake_address.cql");

/// Get assets by stake address query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetAssetsByStakeAddressParams {
    /// Stake address.
    stake_address: Vec<u8>,
    /// Max slot num.
    slot_no: DbSlot,
}

impl GetAssetsByStakeAddressParams {
    /// Creates a new [`GetAssetsByStakeAddressParams`].
    pub(crate) fn new(stake_address: Vec<u8>, slot_no: Slot) -> Self {
        Self {
            stake_address,
            slot_no: slot_no.into(),
        }
    }
}

/// Get native assets query.
#[derive(DeserializeRow)]
pub(crate) struct GetAssetsByStakeAddressQuery {
    /// TXO transaction index within the slot.
    pub txn_index: DbTxnIndex,
    /// TXO index.
    pub txo: DbTxnOutputOffset,
    /// TXO transaction slot number.
    pub slot_no: DbSlot,
    /// Asset hash.
    pub policy_id: Vec<u8>,
    /// Asset name.
    pub asset_name: Vec<u8>,
    /// Asset value.
    pub value: num_bigint::BigInt,
}

impl GetAssetsByStakeAddressQuery {
    /// Prepares a get assets by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_ASSETS_BY_STAKE_ADDRESS_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare get assets by stake address."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_ASSETS_BY_STAKE_ADDRESS_QUERY}"))
    }

    /// Executes a get assets by stake address query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetAssetsByStakeAddressParams,
    ) -> anyhow::Result<TypedRowStream<GetAssetsByStakeAddressQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::AssetsByStakeAddress, params)
            .await?
            .rows_stream::<GetAssetsByStakeAddressQuery>()?;

        Ok(iter)
    }
}
