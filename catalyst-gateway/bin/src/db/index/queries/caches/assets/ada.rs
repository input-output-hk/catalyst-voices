//! Cache for TXO ADA Assets by Stake Address Queries
use std::sync::Arc;

use get_size2::GetSize;
use moka::policy::EvictionPolicy;
use tracing::{debug, error};

use crate::{
    db::{
        index::queries::staked_ada::{
            get_txo_by_stake_address::{GetTxoByStakeAddressQuery, GetTxoByStakeAddressQueryKey},
            update_txo_spent::UpdateTxoSpentQueryParams,
        },
        types::DbStakeAddress,
    },
    metrics::caches::txo_assets::{txo_assets_hits_inc, txo_assets_misses_inc},
    service::utilities::cache::Cache,
    settings::Settings,
};

/// Cache for TXO ADA Assets by Stake Address Queries for Persistent Sessions
pub(crate) struct AssetsAdaCache {
    /// Interior cache type.
    inner: Cache<DbStakeAddress, Arc<Vec<GetTxoByStakeAddressQuery>>>,
}

impl AssetsAdaCache {
    /// Name for cache
    const CACHE_NAME: &str = "Cardano UTXO ADA Assets Cache";

    /// Function to determine the weighted size of cache entries.
    ///
    /// Returns the number of TXOs associated with a Stake Address.
    fn weigher_fn(k: &DbStakeAddress, v: &Arc<Vec<GetTxoByStakeAddressQuery>>) -> u32 {
        let k_size = GetSize::get_size(&k);
        let v_size = GetSize::get_size(&v);
        k_size.saturating_add(v_size).try_into().unwrap_or(u32::MAX)
    }

    /// New ADA Assets Cache instance.
    ///
    /// # Arguments
    /// * `is_persistent` - If the `CassandraSession` is persistent.
    ///
    /// Disables the cache for Volatile sessions (`is_persistent` is `false`).
    pub(crate) fn new(is_persistent: bool) -> Self {
        let max_capacity = if is_persistent {
            Settings::cardano_assets_cache().utxo_cache_size()
        } else {
            0
        };
        Self {
            inner: Cache::new(
                Self::CACHE_NAME,
                EvictionPolicy::lru(),
                max_capacity,
                Self::weigher_fn,
            ),
        }
    }

    /// Get an entry from the cache
    pub(crate) fn get(&self, key: &DbStakeAddress) -> Option<Arc<Vec<GetTxoByStakeAddressQuery>>> {
        // Exit if cache is not enabled to avoid metric updates.
        if !self.inner.is_enabled() {
            return None;
        }
        self.inner
            .get(key)
            .inspect(|_| txo_assets_hits_inc())
            .or_else(|| {
                txo_assets_misses_inc();
                None
            })
    }

    /// Get an entry from the cache
    pub(crate) fn insert(&self, key: DbStakeAddress, value: Arc<Vec<GetTxoByStakeAddressQuery>>) {
        self.inner.insert(key, value);
    }

    /// Clear (invalidates) the cache entries.
    pub(crate) fn clear_cache(&self) {
        self.inner.clear_cache();
    }

    /// Weighted-size of the cache.
    pub(crate) fn weighted_size(&self) -> u64 {
        self.inner.weighted_size()
    }

    /// Number of entries in the cache.
    pub(crate) fn entry_count(&self) -> u64 {
        self.inner.entry_count()
    }

    /// Update spent TXO Assets in Cache.
    pub(crate) fn update(&self, params: Vec<UpdateTxoSpentQueryParams>) {
        // Exit if cache is not enabled to avoid processing params.
        if !self.inner.is_enabled() {
            return;
        }
        for txo_update in params {
            let stake_address = &txo_update.stake_address;
            let update_key = &GetTxoByStakeAddressQueryKey {
                txn_index: txo_update.txn_index,
                txo: txo_update.txo,
                slot_no: txo_update.slot_no,
            };
            let Some(txo_rows) = self.inner.get(stake_address) else {
                debug!(
                    %stake_address,
                    txn_index = i16::from(txo_update.txn_index),
                    txo = i16::from(txo_update.txo),
                    slot_no = u64::from(txo_update.slot_no),
                    "Stake Address not found in TXO Assets Cache, cannot update.");
                continue;
            };
            let Some(txo) = txo_rows.iter().find(|tx| tx.key.as_ref() == update_key) else {
                debug!(
                    %stake_address,
                    txn_index = i16::from(update_key.txn_index),
                    txo = i16::from(update_key.txo),
                    slot_no = u64::from(update_key.slot_no),
                    "TXO for Stake Address does not exist, cannot update.");
                continue;
            };
            // Avoid writing if txo has already been spent,
            if txo.is_spent() {
                debug!(
                    %stake_address,
                    txn_index = i16::from(update_key.txn_index),
                    txo = i16::from(update_key.txo),
                    slot_no = u64::from(update_key.slot_no),
                    "TXO for Stake Address was already spent!");
                continue;
            }

            let mut value = txo.value.write().unwrap_or_else(|error| {
                error!(
                    %stake_address,
                    txn_index = i16::from(update_key.txn_index),
                    txo = i16::from(update_key.txo),
                    slot_no = u64::from(update_key.slot_no),
                    %error,
                    "RwLock for cache entry is poisoned, recovering.");
                txo.value.clear_poison();
                error.into_inner()
            });
            // update spent_slot in cache
            value.spent_slot.replace(txo_update.spent_slot);
            debug!(
                %stake_address,
                txn_index = i16::from(update_key.txn_index),
                txo = i16::from(update_key.txo),
                slot_no = u64::from(update_key.slot_no),
                "Updated TXO for Stake Address");
        }
    }
}
