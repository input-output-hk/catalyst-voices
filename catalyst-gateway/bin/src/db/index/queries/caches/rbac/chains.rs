//! RBAC Persistent Chains Cache.

use catalyst_types::catalyst_id::CatalystId;
use moka::policy::EvictionPolicy;
use rbac_registration::registration::cardano::RegistrationChain;

use crate::{service::utilities::cache::Cache, settings::Settings};

/// RBAC Chains Cache.
pub(crate) struct ChainsCache {
    /// Interior cache type.
    inner: Cache<CatalystId, RegistrationChain>,
}

impl ChainsCache {
    /// Name for cache
    const CACHE_NAME: &str = "RBAC Persistent Chains Cache";

    /// New Chains Cache instance.
    ///
    /// # Arguments
    /// * `is_persistent` - If the `CassandraSession` is persistent.
    ///
    /// Disables the cache for Volatile sessions (`is_persistent` is `false`).
    pub(crate) fn new(is_persistent: bool) -> Self {
        let max_capacity = if is_persistent {
            Settings::rbac_cfg().persistent_chains_cache_size
        } else {
            0
        };
        Self {
            inner: Cache::new(Self::CACHE_NAME, EvictionPolicy::lru(), max_capacity),
        }
    }

    /// Get an entry from the cache
    pub(crate) fn get(
        &self,
        key: &CatalystId,
    ) -> Option<RegistrationChain> {
        self.inner.get(key)
    }

    /// Get an entry from the cache
    pub(crate) fn insert(
        &self,
        key: CatalystId,
        value: RegistrationChain,
    ) {
        self.inner.insert(key, value);
    }

    /// Weighted-size of the cache.
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
