//! A RBAC cache manager.

// TODO(stanislav-tkach): Handle the rollback of volatile registrations.

use std::time::Instant;

use cardano_blockchain_types::StakeAddress;
use catalyst_types::catalyst_id::CatalystId;
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};
use tokio::sync::broadcast;

use super::{event, event::EventTarget};
use crate::rbac_cache::{add_result::AddResult, cache::RbacCache};

/// The capacity of the broadcast channel buffer.
const BROADCAST_CHANNEL_CAPACITY: usize = 1000;

/// A wrapper that allows managing both persistent and volatile caches at the same time.
pub struct RbacCacheManager {
    /// A cache for persistent RBAC data.
    persistent: RbacCache,
    /// A cache for volatile RBAC data.
    volatile: RbacCache,
    /// Event sender during the lifetime of the cache manager.
    event_channel: (
        broadcast::Sender<event::RbacCacheManagerEvent>,
        broadcast::Receiver<event::RbacCacheManagerEvent>,
    ),
}

impl RbacCacheManager {
    /// Creates a new `RbacCacheManager` instance.
    pub fn new() -> Self {
        let persistent = RbacCache::new();
        let volatile = RbacCache::new();

        Self {
            persistent,
            volatile,
            event_channel: broadcast::channel(BROADCAST_CHANNEL_CAPACITY),
        }
    }

    /// Adds the given registration to one of the existing chains or starts a new one.
    ///
    /// In case of failure a problem report from the given registration is updated and
    /// returned.
    #[allow(clippy::result_large_err)]
    pub fn add(&self, registration: Cip509, is_persistent: bool) -> AddResult {
        if is_persistent {
            self.persistent.add(registration.clone())
        } else {
            self.volatile.add(registration)
        }
    }

    /// Returns a registration chain by the given Catalyst ID.
    pub fn get(&self, id: &CatalystId, is_persistent: bool) -> Option<RegistrationChain> {
        let start = Instant::now();

        let result = if is_persistent {
            self.persistent.get(id)
        } else {
            self.volatile.get(id)
        };

        self.dispatch_event(event::RbacCacheManagerEvent::CacheAccessed {
            latency: start.elapsed(),
            is_persistent,
            is_found: result.is_some(),
        });

        result
    }

    /// Returns a registration chain by the stake address.
    pub fn get_by_address(
        &self, address: &StakeAddress, is_persistent: bool,
    ) -> Option<RegistrationChain> {
        if is_persistent {
            self.persistent.get_by_address(address)
        } else {
            self.volatile.get_by_address(address)
        }
    }

    /// Returns a list of active stake addresses of the given registration chain.
    ///
    /// One or all addresses of the chain can be "taken" by another "restarting"
    /// registration. See [RBAC examples] for more details.
    ///
    /// [RBAC examples]: https://github.com/input-output-hk/catalyst-libs/blob/main/rust/rbac-registration/examples.md
    pub fn active_stake_addresses(
        &self, id: &CatalystId, is_persistent: bool,
    ) -> Vec<StakeAddress> {
        if is_persistent {
            self.persistent.active_stake_addresses(id)
        } else {
            self.volatile.active_stake_addresses(id)
        }
    }

    /// Returns the number of cached chain entries from both persistent and volatile.
    pub fn rbac_entries(&self) -> u64 {
        self.persistent
            .chain_entries()
            .checked_add(self.volatile.chain_entries())
            .unwrap_or_default()
    }
}

impl event::EventTarget<event::RbacCacheManagerEvent> for RbacCacheManager {
    fn add_event_listener(&self, listener: event::EventListenerFn<event::RbacCacheManagerEvent>) {
        let mut rx = self.event_channel.0.subscribe();
        tokio::spawn(async move {
            while let Ok(event) = rx.recv().await {
                (listener)(&event);
            }
        });
    }

    fn dispatch_event(&self, message: event::RbacCacheManagerEvent) {
        let _ = self.event_channel.0.send(message);
    }
}
