//! RBAC Catalyst ID by Public Key Cache.

use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;
use moka::policy::EvictionPolicy;

use crate::{service::utilities::cache::Cache, settings::Settings};

/// RBAC Catalyst ID by Public Key Cache.
pub(crate) struct PublicKeyCache {
    /// Interior cache type.
    inner: Cache<VerifyingKey, CatalystId>,
}

impl PublicKeyCache {
    /// Name for cache
    const CACHE_NAME: &str = "RBAC Catalyst ID by Public Key Cache";

    /// New Stake Address Cache instance.
    pub(crate) fn new(is_persistent: bool) -> Self {
        let max_capacity = if is_persistent {
            Settings::rbac_cfg().persistent_pub_keys_cache_size
        } else {
            Settings::rbac_cfg().volatile_pub_keys_cache_size
        };
        Self {
            inner: Cache::new(Self::CACHE_NAME, EvictionPolicy::lru(), max_capacity),
        }
    }

    /// Get an entry from the cache
    pub(crate) fn get(&self, key: &VerifyingKey) -> Option<CatalystId> {
        self.inner.get(key)
    }

    /// Get an entry from the cache
    pub(crate) fn insert(&self, key: VerifyingKey, value: CatalystId) {
        self.inner.insert(key, value);
    }

    /// Clear (invalidates) the cache entries.
    pub(crate) fn clear_cache(&self) {
        self.inner.clear_cache();
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
