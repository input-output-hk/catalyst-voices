//! RBAC Stake Address Cache.

use cardano_blockchain_types::StakeAddress;
use catalyst_types::catalyst_id::CatalystId;
use moka::policy::EvictionPolicy;

use crate::{service::utilities::cache::Cache, settings::Settings};

/// RBAC Stake Address Cache.
pub(crate) struct StakeAddressCache {
    /// Interior cache type.
    inner: Cache<StakeAddress, CatalystId>,
}

impl StakeAddressCache {
    /// Name for cache
    const CACHE_NAME: &str = "RBAC Stake Address Cache";

    /// Function to determine cache entry weighted size.
    fn weigher_fn(_: &StakeAddress, _: &CatalystId) -> u32 {
        1u32
    }

    /// New Stake Address Cache instance.
    pub(crate) fn new() -> Self {
        Self {
            inner: Cache::new(
                Self::CACHE_NAME,
                EvictionPolicy::lru(),
                Settings::rbac_cfg().persistent_pub_keys_cache_size,
                Self::weigher_fn,
            ),
        }
    }

    /// Get an entry from the cache
    pub(crate) fn get(&self, key: &StakeAddress) -> Option<CatalystId> {
        self.inner.get(key)
    }

    /// Get an entry from the cache
    pub(crate) fn insert(&self, key: StakeAddress, value: CatalystId) {
        self.inner.insert(key, value);
    }

    /// Clear (invalidates) the cache entries.
    pub(crate) fn clear_cache(&self) {
        self.inner.clear_cache();
    }

    /// Number of entries in the cache.
    pub(crate) fn entry_count(&self) -> u64 {
        self.inner.entry_count()
    }
}
