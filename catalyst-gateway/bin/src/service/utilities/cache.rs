//! Cache wrapper type
use std::{collections::hash_map::RandomState, hash::Hash};

use moka::{policy::EvictionPolicy, sync::Cache};

/// Cache type that is disabled if the maximum capacity is set to zero.
pub(crate) struct CacheWrapper<K, V> {
    /// Optional `moka::sync::Cache`.
    inner: Option<Cache<K, V, RandomState>>,
}

impl<K, V> CacheWrapper<K, V>
where
    K: Hash + Eq + Send + Sync + 'static,
    V: Clone + Send + Sync + 'static,
{
    /// Constructs a new `CacheWrapper`.
    pub(crate) fn new(name: &str, eviction_policy: EvictionPolicy, max_capacity: u64) -> Self {
        let inner = if max_capacity < 1 {
            None
        } else {
            let cache = Cache::builder()
                .name(name)
                .eviction_policy(eviction_policy)
                .max_capacity(max_capacity)
                .build();
            Some(cache)
        };
        Self { inner }
    }

    /// Get entry from the cache by key.
    pub(crate) fn get(&self, key: &K) -> Option<V> {
        self.inner.as_ref().and_then(|cache| cache.get(key))
    }

    /// Insert entry into the cache.
    pub(crate) fn insert(&self, key: K, value: V) {
        self.inner
            .as_ref()
            .inspect(|cache| cache.insert(key, value));
    }

    /// Clear entries in the cache.
    pub(crate) fn clear_cache(&self) {
        self.inner.as_ref().inspect(|cache| cache.invalidate_all());
    }

    /// Weighted-size of the cache.
    pub(crate) fn size(&self) -> u64 {
        self.inner
            .as_ref()
            .inspect(|cache| {
                cache.run_pending_tasks();
            })
            .map(Cache::weighted_size)
            .unwrap_or_default()
    }

    /// Number of entries in the cache.
    pub(crate) fn entry_count(&self) -> u64 {
        self.inner
            .as_ref()
            .inspect(|cache| {
                cache.run_pending_tasks();
            })
            .map(Cache::entry_count)
            .unwrap_or_default()
    }

    /// Returns `true` if the cache is enabled.
    pub(crate) fn is_enabled(&self) -> bool {
        self.inner.is_some()
    }
}
