//! Get assets by stake address.
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

/// Get assets by stake address query string.
const GET_ASSETS_BY_STAKE_ADDRESS_QUERY: &str =
    include_str!("../cql/get_assets_by_stake_address.cql");

/// Get assets by stake address query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetAssetsByStakeAddressParams {
    /// Stake address.
    stake_address: Vec<u8>,
    /// Max slot num.
    slot_no: num_bigint::BigInt,
}

impl GetAssetsByStakeAddressParams {
    /// Creates a new [`GetAssetsByStakeAddressParams`].
    pub(crate) fn new(stake_address: Vec<u8>, slot_no: num_bigint::BigInt) -> Self {
        Self {
            stake_address,
            slot_no,
        }
    }
}

/// Get native assets query.
#[derive(DeserializeRow)]
pub(crate) struct GetAssetsByStakeAddressQuery {
    /// TXO transaction index within the slot.
    pub txn: i16,
    /// TXO index.
    pub txo: i16,
    /// TXO transaction slot number.
    pub slot_no: num_bigint::BigInt,
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
        let get_assets_by_stake_address_query = PreparedQueries::prepare(
            session,
            GET_ASSETS_BY_STAKE_ADDRESS_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_assets_by_stake_address_query {
            error!(error=%error, "Failed to prepare get assets by stake address");
        };

        get_assets_by_stake_address_query
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
