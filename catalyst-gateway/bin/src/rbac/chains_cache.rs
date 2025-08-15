//! A cache of RBAC chains.

use std::sync::LazyLock;

use catalyst_types::catalyst_id::CatalystId;
use moka::policy::EvictionPolicy;
use rbac_registration::registration::cardano::RegistrationChain;

use crate::{
    metrics::rbac::reporter::{PERSISTENT_CHAINS_CACHE_HIT, PERSISTENT_CHAINS_CACHE_MISS},
    service::utilities::cache::CacheWrapper,
    settings::Settings,
};

/// Function to determine cache entry weighted size.
fn weigher_fn(_: &CatalystId, _: &RegistrationChain) -> u32 {
    1u32
}

/// A cache of persistent RBAC chains.
static PERSISTENT_CHAINS: LazyLock<CacheWrapper<CatalystId, RegistrationChain>> =
    LazyLock::new(|| {
        CacheWrapper::new(
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
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    let res = PERSISTENT_CHAINS.get(id);
    if res.is_some() {
        PERSISTENT_CHAINS_CACHE_HIT
            .with_label_values(&[&api_host_names, service_id, &network])
            .inc();
    } else {
        PERSISTENT_CHAINS_CACHE_MISS
            .with_label_values(&[&api_host_names, service_id, &network])
            .inc();
    }
    res
}

/// Returns an approximate number of entries in the `PERSISTENT_CHAINS` cache.
pub fn persistent_rbac_chains_cache_size() -> u64 {
    PERSISTENT_CHAINS.entry_count()
}
