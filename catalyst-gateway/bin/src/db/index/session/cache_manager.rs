//! Manager for the different Caches used by the Cassandra Session.
use std::sync::Arc;

use crate::db::index::queries::caches::rbac::stake_address::StakeAddressCache;

/// Manager for the different Caches used by the Cassandra Session.
pub(crate) struct Caches {
    /// RBAC Stake Address Caches
    rbac_stake_address: Arc<StakeAddressCache>,
}

impl Caches {
    /// Initialize Session Caches
    pub(crate) fn new() -> Self {
        Self {
            rbac_stake_address: Arc::new(StakeAddressCache::new()),
        }
    }

    /// RBAC Stake Address Cache
    pub(crate) fn rbac_stake_address(&self) -> Arc<StakeAddressCache> {
        self.rbac_stake_address.clone()
    }
}
