//! A cache of RBAC chains.

use std::sync::LazyLock;

use catalyst_types::catalyst_id::CatalystId;
use moka::policy::EvictionPolicy;
use rbac_registration::registration::cardano::RegistrationChain;

use crate::{
    metrics::rbac::{rbac_persistent_chains_cache_hits_inc, rbac_persistent_chains_cache_miss_inc},
    service::utilities::cache::Cache,
    settings::Settings,
};

/// Function to determine cache entry weighted size.
fn weigher_fn(_: &CatalystId, _: &RegistrationChain) -> u32 {
    1u32
}

/// A cache of persistent RBAC chains.
static PERSISTENT_CHAINS: LazyLock<Cache<CatalystId, RegistrationChain>> = LazyLock::new(|| {
    Cache::new(
        "Persistent RBAC Chains Cache",
        EvictionPolicy::lru(),
        Settings::rbac_cfg().persistent_chains_cache_size,
        weigher_fn,
    )
});

/// Add (or update) a persistent chain to the cache.
pub fn cache_persistent_rbac_chain(id: CatalystId, chain: RegistrationChain) {
    PERSISTENT_CHAINS.insert(id, chain);
}

/// Returns a cached persistent chain by the given Catalyst ID.
pub fn cached_persistent_rbac_chain(id: &CatalystId) -> Option<RegistrationChain> {
    let res = PERSISTENT_CHAINS.get(id);
    if res.is_some() {
        rbac_persistent_chains_cache_hits_inc();
    } else {
        rbac_persistent_chains_cache_miss_inc();
    }
    res
}

/// Returns an approximate number of entries in the `PERSISTENT_CHAINS` cache.
pub fn persistent_rbac_chains_cache_size() -> u64 {
    PERSISTENT_CHAINS.entry_count()
}
