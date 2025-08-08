//! Cache for Native Assets by Stake Address Queries
use std::sync::{Arc, LazyLock};

use moka::policy::EvictionPolicy;

use crate::{
    db::{index::queries::GetAssetsByStakeAddressQuery, types::DbStakeAddress},
    metrics::caches::native_assets::{native_assets_hits_inc, native_assets_misses_inc},
    service::utilities::cache::CacheWrapper,
    settings::Settings,
};

/// In memory cache of the Cardano Native assets data
static ASSETS_CACHE: LazyLock<
    CacheWrapper<DbStakeAddress, Arc<Vec<GetAssetsByStakeAddressQuery>>>,
> = LazyLock::new(|| {
    let max_capacity = Settings::cardano_assets_cache().native_assets_cache_size();
    CacheWrapper::new(
        "Cardano Native Assets Cache",
        EvictionPolicy::lru(),
        max_capacity,
    )
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
    ASSETS_CACHE.clear_cache();
}

/// Size of TXO Assets cache.
pub(crate) fn size() -> u64 {
    ASSETS_CACHE.size()
}
/// Number of entries in TXO Assets cache.
pub(crate) fn entry_count() -> u64 {
    ASSETS_CACHE.entry_count()
}
