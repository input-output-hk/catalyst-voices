//! RBAC Catalyst ID by Stake Address Cache.

use cardano_chain_follower::StakeAddress;
use catalyst_types::catalyst_id::CatalystId;
use get_size2::GetSize;
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
    fn weigher_fn(k: &StakeAddress, v: &CatalystId) -> u32 {
        let k_size = GetSize::get_size(&k);
        let v_size = GetSize::get_size(&v);
        k_size.saturating_add(v_size).try_into().unwrap_or(u32::MAX)
    }

    /// New Stake Address Cache instance.
    pub(crate) fn new(is_persistent: bool) -> Self {
        let max_capacity = if is_persistent {
            Settings::rbac_cfg().persistent_stake_addresses_cache_size
        } else {
            Settings::rbac_cfg().volatile_stake_addresses_cache_size
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

    /// Weighted-size of the cache.
    #[allow(dead_code)]
    pub(crate) fn weighted_size(&self) -> u64 {
        self.inner.weighted_size()
    }

    /// Number of entries in the cache.
    pub(crate) fn entry_count(&self) -> u64 {
        self.inner.entry_count()
    }

    /// Returns `true` if the cache is enabled.
    pub(crate) fn is_enabled(&self) -> bool {
        self.inner.is_enabled()
    }
}
