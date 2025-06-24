//! A cache of RBAC chains.

use std::sync::LazyLock;

use catalyst_types::catalyst_id::CatalystId;
use moka::{policy::EvictionPolicy, sync::Cache};
use rbac_registration::registration::cardano::RegistrationChain;

use crate::settings::Settings;

/// A cache of persistent RBAC chains.
static PERSISTENT_CHAINS: LazyLock<Cache<CatalystId, RegistrationChain>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .max_capacity(Settings::rbac_cfg().persistent_chains_cache_size)
        .build()
});

/// Add (or update) a persistent chain to the cache.
pub fn cache_persistent_rbac_chain(id: CatalystId, chain: RegistrationChain) {
    PERSISTENT_CHAINS.insert(id, chain);
}

/// Returns a cached persistent chain by the given Catalyst ID.
pub fn cached_persistent_rbac_chain(id: &CatalystId) -> Option<RegistrationChain> {
    PERSISTENT_CHAINS.get(id)
}
