//! Cache for Native Assets by Stake Address Queries
use std::sync::Arc;

use moka::policy::EvictionPolicy;

use crate::{
    db::{index::queries::GetAssetsByStakeAddressQuery, types::DbStakeAddress},
    metrics::caches::native_assets::{native_assets_hits_inc, native_assets_misses_inc},
    service::utilities::cache::Cache,
    settings::Settings,
};

/// Cache for TXO Native Assets by Stake Address Queries for Persistent Sessions
pub(crate) struct AssetsNativeCache {
    /// Interior cache type.
    inner: Cache<DbStakeAddress, Arc<Vec<GetAssetsByStakeAddressQuery>>>,
}

impl AssetsNativeCache {
    /// Name for cache
    const CACHE_NAME: &str = "Cardano UTXO Native Assets Cache";

    /// Function to determine the weighted size of cache entries.
    ///
    /// Returns the number of TXOs associated with a Stake Address.
    fn weigher_fn(_k: &DbStakeAddress, v: &Arc<Vec<GetAssetsByStakeAddressQuery>>) -> u32 {
        v.len().try_into().unwrap_or(u32::MAX)
    }

    /// New Native Assets Cache instance.
    ///
    /// # Arguments
    /// * `is_persistent` - If the `CassandraSession` is persistent.
    ///
    /// Disables the cache for Volatile sessions (`is_persistent` is `false`).
    pub(crate) fn new(is_persistent: bool) -> Self {
        let max_capacity = if is_persistent {
            Settings::cardano_assets_cache().native_assets_cache_size()
        } else {
            0
        };
        Self {
            inner: Cache::new(
                Self::CACHE_NAME,
                EvictionPolicy::lru(),
                max_capacity,
                Self::weigher_fn,
            ),
        }
    }

    /// Get Native Assets entry from Cache.
    pub(crate) fn get(
        &self, stake_address: &DbStakeAddress,
    ) -> Option<Arc<Vec<GetAssetsByStakeAddressQuery>>> {
        // Exit if cache is not enabled to avoid metric updates.
        if !self.inner.is_enabled() {
            return None;
        }
        self.inner
            .get(stake_address)
            .inspect(|_| native_assets_hits_inc())
            .or_else(|| {
                native_assets_misses_inc();
                None
            })
    }

    /// Insert Native Assets entry in Cache.
    pub(crate) fn insert(
        &self, stake_address: DbStakeAddress, rows: Arc<Vec<GetAssetsByStakeAddressQuery>>,
    ) {
        self.inner.insert(stake_address, rows);
    }

    /// Clear (invalidates) the cache entries.
    pub(crate) fn clear_cache(&self) {
        self.inner.clear_cache();
    }

    /// Size of TXO Assets cache.
    pub(crate) fn weighted_size(&self) -> u64 {
        self.inner.weighted_size()
    }

    /// Number of entries in TXO Assets cache.
    pub(crate) fn entry_count(&self) -> u64 {
        self.inner.entry_count()
    }
}
