//! Get assets by stake address.
use std::sync::{Arc, LazyLock};

use cardano_blockchain_types::StakeAddress;
use futures::TryStreamExt;
use scylla::{prepared_statement::PreparedStatement, DeserializeRow, SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{PreparedQueries, PreparedSelectQuery},
            session::CassandraSession,
        },
        types::{DbSlot, DbStakeAddress, DbTxnIndex, DbTxnOutputOffset},
    },
    settings::Settings,
};

/// Get assets by stake address query string.
const GET_ASSETS_BY_STAKE_ADDRESS_QUERY: &str =
    include_str!("../cql/get_assets_by_stake_address.cql");

/// In memory cache of the Cardano native assets data
static ASSETS_CACHE: LazyLock<
    moka::future::Cache<DbStakeAddress, Vec<GetAssetsByStakeAddressQuery>>,
> = LazyLock::new(|| {
    moka::future::Cache::builder()
        .name("Cardano native assets cache")
        .max_capacity(Settings::cardano_assets_cache().native_assets_cache_size())
        .build()
});

/// Get assets by stake address query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetAssetsByStakeAddressParams {
    /// Stake address.
    stake_address: DbStakeAddress,
}

impl GetAssetsByStakeAddressParams {
    /// Creates a new [`GetAssetsByStakeAddressParams`].
    pub(crate) fn new(stake_address: StakeAddress) -> Self {
        Self {
            stake_address: stake_address.into(),
        }
    }
}

/// Get native assets query.
#[derive(DeserializeRow, Clone)]
pub(crate) struct GetAssetsByStakeAddressQuery {
    /// TXO transaction index within the slot.
    pub txn_index: DbTxnIndex,
    /// TXO index.
    pub txo: DbTxnOutputOffset,
    /// TXO transaction slot number.
    pub slot_no: DbSlot,
    /// Asset policy hash (28 bytes).
    pub policy_id: Vec<u8>,
    /// Asset name (range of 0 - 32 bytes)
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
    ) -> anyhow::Result<Vec<GetAssetsByStakeAddressQuery>> {
        if session.is_persistent() {
            if let Some(res) = ASSETS_CACHE.get(&params.stake_address).await {
                return Ok(res);
            }
        }

        let res = session
            .execute_iter(PreparedSelectQuery::AssetsByStakeAddress, &params)
            .await?
            .rows_stream::<GetAssetsByStakeAddressQuery>()?
            .map_err(Into::<anyhow::Error>::into)
            .try_fold(Vec::new(), |mut res: Vec<_>, item| {
                async move {
                    res.push(item);
                    Ok(res)
                }
            })
            .await?;
        // update cache
        if session.is_persistent() {
            ASSETS_CACHE.insert(params.stake_address, res.clone()).await;
        }
        Ok(res)
    }

    /// Fully drops the underlying Cardano native assets cache.
    /// Its totally safe operation and only could have a performance implications, because
    /// of the empty cache.
    pub(crate) fn drop_cache() {
        ASSETS_CACHE.invalidate_all();
    }
}
