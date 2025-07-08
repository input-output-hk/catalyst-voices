//! Cache for Native Assets by Stake Address Queries
use std::sync::{Arc, LazyLock};

use moka::{policy::EvictionPolicy, sync::Cache};

use crate::{
    db::{index::queries::GetAssetsByStakeAddressQuery, types::DbStakeAddress},
    metrics::caches::native_assets::{native_assets_hits_inc, native_assets_misses_inc},
    settings::Settings,
};

/// In memory cache of the Cardano Native assets data
static ASSETS_CACHE: LazyLock<Cache<DbStakeAddress, Arc<Vec<GetAssetsByStakeAddressQuery>>>> =
    LazyLock::new(|| {
        Cache::builder()
            .name("Cardano native assets cache")
            .eviction_policy(EvictionPolicy::lru())
            .max_capacity(Settings::cardano_assets_cache().native_assets_cache_size())
            .build()
    });

/// Get Native Assets entry from Cache.
pub(crate) fn get(
    stake_address: &DbStakeAddress,
) -> Option<Arc<Vec<GetAssetsByStakeAddressQuery>>> {
    ASSETS_CACHE
        .get(stake_address)
        .inspect(|_| native_assets_hits_inc())
        .or_else(|| {
            native_assets_misses_inc();
            None
        })
}

/// Insert Native Assets entry in Cache.
pub(crate) fn insert(stake_address: DbStakeAddress, rows: Arc<Vec<GetAssetsByStakeAddressQuery>>) {
    ASSETS_CACHE.insert(stake_address, rows);
}

/// Empty the Native assets cache.
pub(crate) fn drop() {
    ASSETS_CACHE.invalidate_all();
}
