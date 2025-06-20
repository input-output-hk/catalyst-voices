//! A cache of RBAC chains.

use std::sync::LazyLock;

use ed25519_dalek::VerifyingKey;
use moka::{policy::EvictionPolicy, sync::Cache};
use rbac_registration::registration::cardano::RegistrationChain;

use crate::settings::Settings;

/// A cache of persistent RBAC chains.
static PERSISTENT_CHAINS: LazyLock<Cache<VerifyingKey, RegistrationChain>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .max_capacity(Settings::rbac_cfg().persistent_chains_cache_size)
        .build()
});
