//! Environment variable settings for the Cardano assets in memory cache

use crate::settings::str_env_var::StringEnvVar;

/// Default value for the Cardano UTXO cache size (disabled cache)
const DEFAULT_CARDANO_UTXO_CACHE_SIZE: u64 = 0;

/// Default value for the Cardano native assets cache size (disabled cache)
const DEFAULT_CARDANO_NATIVE_ASSETS_CACHE_SIZE: u64 = 0;

/// Configuration for Cardano assets in memory cache.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// Maximum Cardano UTXO cache size value.
    /// `CARDANO_UTXO_CACHE_SIZE` env var.
    utxo_cache_size: u64,
    /// Maximum Cardano native assets cache size value.
    /// `CARDANO_NATIVE_ASSETS_CACHE_SIZE` env var
    native_assets_cache_size: u64,
}

impl EnvVars {
    /// Create a config for assets in memory cache.
    pub(super) fn new() -> Self {
        Self {
            utxo_cache_size: StringEnvVar::new_as_int(
                "CARDANO_UTXO_CACHE_SIZE",
                DEFAULT_CARDANO_UTXO_CACHE_SIZE,
                0,
                u64::MAX,
            ),
            native_assets_cache_size: StringEnvVar::new_as_int(
                "CARDANO_NATIVE_ASSETS_CACHE_SIZE",
                DEFAULT_CARDANO_UTXO_CACHE_SIZE,
                0,
                u64::MAX,
            ),
        }
    }
}
