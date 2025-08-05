//! Cache for TXO Assets by Stake Address Queries
use std::sync::{Arc, LazyLock};

use moka::{policy::EvictionPolicy, sync::Cache};
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
    settings::Settings,
};

/// In memory cache of the most recent Cardano TXO assets by Stake Address.
static ASSETS_CACHE: LazyLock<Cache<DbStakeAddress, Arc<Vec<GetTxoByStakeAddressQuery>>>> =
    LazyLock::new(|| {
        Cache::builder()
            .name("Cardano UTXO Assets Cache")
            .eviction_policy(EvictionPolicy::lru())
            .max_capacity(Settings::cardano_assets_cache().utxo_cache_size())
            .build()
    });

/// Returns true if Cache is enabled.
fn is_enabled() -> bool {
    Settings::cardano_assets_cache().utxo_cache_size() > 0
}

/// Get TXO Assets entry from Cache.
pub(crate) fn get(stake_address: &DbStakeAddress) -> Option<Arc<Vec<GetTxoByStakeAddressQuery>>> {
    if !is_enabled() {
        return None;
    }
    ASSETS_CACHE
        .get(stake_address)
        .inspect(|_| txo_assets_hits_inc())
        .or_else(|| {
            txo_assets_misses_inc();
            None
        })
}

/// Insert TXO Assets entry in Cache.
pub(crate) fn insert(stake_address: DbStakeAddress, rows: Arc<Vec<GetTxoByStakeAddressQuery>>) {
    if !is_enabled() {
        return;
    }
    ASSETS_CACHE.insert(stake_address, rows);
}

/// Update spent TXO Assets in Cache.
pub(crate) fn update(params: Vec<UpdateTxoSpentQueryParams>) {
    if !is_enabled() {
        return;
    }
    for txo_update in params {
        let stake_address = &txo_update.stake_address;
        let update_key = &GetTxoByStakeAddressQueryKey {
            txn_index: txo_update.txn_index,
            txo: txo_update.txo,
            slot_no: txo_update.slot_no,
        };
        if let Some(txo_rows) = ASSETS_CACHE.get(stake_address) {
            if let Some(txo) = txo_rows
                .clone()
                .iter()
                .find(|tx| tx.key.as_ref() == update_key)
            {
                // Avoid wrting if txo has already been spent,
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
        } else {
            debug!(
                %stake_address,
                txn_index = i16::from(txo_update.txn_index),
                txo = i16::from(txo_update.txo),
                slot_no = u64::from(txo_update.slot_no),
                "Stake Address not found in TXO Assets Cache, cannot update.");
        }
    }
}

/// Empty the TXO Assets cache.
pub(crate) fn drop() {
    if !is_enabled() {
        return;
    }
    ASSETS_CACHE.invalidate_all();
}

/// Size of TXO Assets cache.
pub(crate) fn size() -> u64 {
    if !is_enabled() {
        return 0;
    }
    ASSETS_CACHE.run_pending_tasks();
    ASSETS_CACHE.weighted_size()
}
/// Number of entries in TXO Assets cache.
pub(crate) fn entry_count() -> u64 {
    if !is_enabled() {
        return 0;
    }
    ASSETS_CACHE.run_pending_tasks();
    ASSETS_CACHE.entry_count()
}
