//! Manager for the different Caches used by the Cassandra Session.
use std::sync::Arc;

use crate::db::index::queries::caches::{
    assets::{ada::AssetsAdaCache, native::AssetsNativeCache},
    rbac::{public_key::PublicKeyCache, stake_address::StakeAddressCache},
};

/// Manager for the different Caches used by the Cassandra Session.
pub(crate) struct Caches {
    /// Cache for TXO ADA Assets by Stake Address (disabled for Volatile Sessions)
    assets_ada: Arc<AssetsAdaCache>,
    /// Cache for TXO Native Assets by Stake Address (disabled for Volatile Sessions)
    assets_native: Arc<AssetsNativeCache>,
    ///  Cache for RBAC Catalyst IDs by Public Key
    rbac_public_key: Arc<PublicKeyCache>,
    ///  Cache for RBAC Catalyst IDs by Stake Address
    rbac_stake_address: Arc<StakeAddressCache>,
}

impl Caches {
    /// Initialize Session Caches
    pub(crate) fn new(is_persistent: bool) -> Self {
        Self {
            assets_ada: Arc::new(AssetsAdaCache::new(is_persistent)),
            assets_native: Arc::new(AssetsNativeCache::new(is_persistent)),
            rbac_public_key: Arc::new(PublicKeyCache::new()),
            rbac_stake_address: Arc::new(StakeAddressCache::new()),
        }
    }

    /// UTXO Native Assets Cache
    pub(crate) fn assets_native(&self) -> Arc<AssetsNativeCache> {
        self.assets_native.clone()
    }

    /// UTXO ADA Assets Cache
    pub(crate) fn assets_ada(&self) -> Arc<AssetsAdaCache> {
        self.assets_ada.clone()
    }

    /// RBAC Public Key Cache
    pub(crate) fn rbac_public_key(&self) -> Arc<PublicKeyCache> {
        self.rbac_public_key.clone()
    }

    /// RBAC Stake Address Cache
    pub(crate) fn rbac_stake_address(&self) -> Arc<StakeAddressCache> {
        self.rbac_stake_address.clone()
    }
}
