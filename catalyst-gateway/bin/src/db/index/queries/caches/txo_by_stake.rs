//! Cache for TXO Assets by Stake Address Queries
use std::sync::{Arc, LazyLock};

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
    service::utilities::cache::CacheWrapper,
    settings::Settings,
};

/// Function that returns the number of ADA asset TXOs associated with a Stake Address as
/// the weighted size of a cache entry.
fn weigher_fn(_k: &DbStakeAddress, v: &Arc<Vec<GetTxoByStakeAddressQuery>>) -> u32 {
    v.len().try_into().unwrap_or(u32::MAX)
}

/// In memory cache of the most recent Cardano TXO assets by Stake Address.
static ASSETS_CACHE: LazyLock<CacheWrapper<DbStakeAddress, Arc<Vec<GetTxoByStakeAddressQuery>>>> =
    LazyLock::new(|| {
        let max_capacity = Settings::cardano_assets_cache().utxo_cache_size();
        CacheWrapper::new(
            "Cardano UTXO Assets Cache",
            EvictionPolicy::lru(),
            max_capacity,
            weigher_fn,
        )
    });

/// Get TXO Assets entry from Cache.
pub(crate) fn get(stake_address: &DbStakeAddress) -> Option<Arc<Vec<GetTxoByStakeAddressQuery>>> {
    // Exit if cache is not enabled to avoid metric updates.
    if !ASSETS_CACHE.is_enabled() {
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
    ASSETS_CACHE.insert(stake_address, rows);
}

/// Empty the TXO Assets cache.
pub(crate) fn drop() {
    ASSETS_CACHE.clear_cache();
}

/// Size of TXO Assets cache.
pub(crate) fn size() -> u64 {
    ASSETS_CACHE.size()
}
/// Number of entries in TXO Assets cache.
pub(crate) fn entry_count() -> u64 {
    ASSETS_CACHE.entry_count()
}

/// Update spent TXO Assets in Cache.
pub(crate) fn update(params: Vec<UpdateTxoSpentQueryParams>) {
    // Exit if cache is not enabled to avoid processing params.
    if !ASSETS_CACHE.is_enabled() {
        return;
    }
    for txo_update in params {
        let stake_address = &txo_update.stake_address;
        let update_key = &GetTxoByStakeAddressQueryKey {
            txn_index: txo_update.txn_index,
            txo: txo_update.txo,
            slot_no: txo_update.slot_no,
        };
        let Some(txo_rows) = ASSETS_CACHE.get(stake_address) else {
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
