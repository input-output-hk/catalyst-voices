//! Command line and environment variable settings for RBAC.

use super::str_env_var::StringEnvVar;

/// A default value of `persistent_chains_cache_size`.
const DEFAULT_PERSISTENT_CHAINS_CACHE_SIZE: u64 = 1000;

/// A default value of `persistent_transactions_cache_size`.
const DEFAULT_PERSISTENT_TRANSACTIONS_CACHE_SIZE: u64 = 1000;

/// A default value of `volatile_transactions_cache_size`.
const DEFAULT_VOLATILE_TRANSACTIONS_CACHE_SIZE: u64 = 200;

/// A default value of `persistent_stake_addresses_cache_size`.
const DEFAULT_PERSISTENT_STAKE_ADDRESSES_CACHE_SIZE: u64 = 1000;

/// A default value of `volatile_stake_addresses_cache_size`.
const DEFAULT_VOLATILE_STAKE_ADDRESSES_CACHE_SIZE: u64 = 200;

/// A default value of `persistent_pub_keys_cache_size`.
const DEFAULT_PERSISTENT_PUB_KEYS_CACHE_SIZE: u64 = 1000;

/// A default value of `volatile_pub_keys_cache_size`.
const DEFAULT_VOLATILE_PUB_KEYS_CACHE_SIZE: u64 = 200;

/// RBAC related configuration options.
// TODO: Remove when used.
#[allow(unused)]
#[allow(clippy::struct_field_names)]
#[derive(Clone)]
pub struct EnvVars {
    /// A maximum size of the persistent RBAC registration chains cache.
    pub persistent_chains_cache_size: u64,

    /// A maximum size of the persistent RBAC transactions cache.
    pub persistent_transactions_cache_size: u64,

    /// A maximum size of the volatile RBAC transactions cache.
    pub volatile_transactions_cache_size: u64,

    /// A maximum size of the persistent stake addresses cache.
    pub persistent_stake_addresses_cache_size: u64,

    /// A maximum size of the volatile stake addresses cache.
    pub volatile_stake_addresses_cache_size: u64,

    /// A maximum size of the persistent public keys cache.
    pub persistent_pub_keys_cache_size: u64,

    /// A maximum size of the volatile public keys cache.
    pub volatile_pub_keys_cache_size: u64,
}

impl EnvVars {
    /// Create a config for Catalyst Signed Document validation configuration.
    pub(super) fn new() -> Self {
        let persistent_chains_cache_size = StringEnvVar::new_as_int(
            "RBAC_PERSISTENT_CHAINS_CACHE_SIZE",
            DEFAULT_PERSISTENT_CHAINS_CACHE_SIZE,
            0,
            u64::MAX,
        );

        let persistent_transactions_cache_size = StringEnvVar::new_as_int(
            "RBAC_PERSISTENT_TRANSACTIONS_CACHE_SIZE",
            DEFAULT_PERSISTENT_TRANSACTIONS_CACHE_SIZE,
            0,
            u64::MAX,
        );
        let volatile_transactions_cache_size = StringEnvVar::new_as_int(
            "RBAC_VOLATILE_TRANSACTIONS_CACHE_SIZE",
            DEFAULT_VOLATILE_TRANSACTIONS_CACHE_SIZE,
            0,
            u64::MAX,
        );

        let persistent_stake_addresses_cache_size = StringEnvVar::new_as_int(
            "RBAC_PERSISTENT_STAKE_ADDRESSES_CACHE_SIZE",
            DEFAULT_PERSISTENT_STAKE_ADDRESSES_CACHE_SIZE,
            0,
            u64::MAX,
        );
        let volatile_stake_addresses_cache_size = StringEnvVar::new_as_int(
            "RBAC_VOLATILE_STAKE_ADDRESSES_CACHE_SIZE",
            DEFAULT_VOLATILE_STAKE_ADDRESSES_CACHE_SIZE,
            0,
            u64::MAX,
        );

        let persistent_pub_keys_cache_size = StringEnvVar::new_as_int(
            "RBAC_PERSISTENT_PUB_KEYS_CACHE_SIZE",
            DEFAULT_PERSISTENT_PUB_KEYS_CACHE_SIZE,
            0,
            u64::MAX,
        );
        let volatile_pub_keys_cache_size = StringEnvVar::new_as_int(
            "RBAC_VOLATILE_PUB_KEYS_CACHE_SIZE",
            DEFAULT_VOLATILE_PUB_KEYS_CACHE_SIZE,
            0,
            u64::MAX,
        );

        Self {
            persistent_chains_cache_size,
            persistent_transactions_cache_size,
            volatile_transactions_cache_size,
            persistent_stake_addresses_cache_size,
            volatile_stake_addresses_cache_size,
            persistent_pub_keys_cache_size,
            volatile_pub_keys_cache_size,
        }
    }
}
