//! Cache for TXO Assets by Stake Address Queries
use std::sync::{Arc, LazyLock};

use moka::{ops::compute::Op, policy::EvictionPolicy, sync::Cache};

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
            .name("Cardano TXO Assets")
            .eviction_policy(EvictionPolicy::lru())
            .max_capacity(Settings::cardano_assets_cache().utxo_cache_size())
            .build()
    });

/// Get TXO Assets entry from Cache.
pub(crate) fn get(stake_address: &DbStakeAddress) -> Option<Arc<Vec<GetTxoByStakeAddressQuery>>> {
    ASSETS_CACHE
        .get(stake_address)
        .inspect(|_| txo_assets_hits_inc())
        .or_else(|| {
            txo_assets_misses_inc();
            None
        })
}

/// Insert TXO Assets entry in Cache.
pub(crate) fn insert(
    stake_address: DbStakeAddress,
    rows: Arc<Vec<GetTxoByStakeAddressQuery>>,
) {
    ASSETS_CACHE.insert(stake_address, rows);
}

/// Update spent TXO Assets in Cache.
pub(crate) fn update(params: Vec<UpdateTxoSpentQueryParams>) {
    for txo_update in params {
        let stake_address = &txo_update.stake_address;
        let update_key = &GetTxoByStakeAddressQueryKey {
            txn_index: txo_update.txn_index,
            txo: txo_update.txo,
            slot_no: txo_update.slot_no,
        };
        let _entry = ASSETS_CACHE
            .entry(stake_address.clone())
            .and_compute_with(|maybe_entry| {
                maybe_entry.map_or_else(
                    || {
                        tracing::debug!(
                        ?txo_update,
                        %stake_address,
                        "Stake Address not found in TXO Assets Cache, cannot update.");
                    },
                    |entry| {
                        if let Some(txo) = entry
                            .into_value()
                            .iter()
                            .find(|t| t.key.as_ref() == update_key)
                        {
                            let mut value = txo.value.write().unwrap_or_else(|error| {
                                tracing::error!(
                                ?txo_update,
                                %stake_address,
                                %error,
                                cache_name = ?ASSETS_CACHE.name(),
                                "RwLock for cache entry is poisoned, recovering.");
                                txo.value.clear_poison();
                                error.into_inner()
                            });
                            value.spent_slot = Some(txo_update.spent_slot);
                            tracing::debug!(
                            ?txo_update,
                            %stake_address,
                            "Updated TXO for Stake Address in Assets Cache");
                        } else {
                            tracing::debug!(
                            ?txo_update,
                            %stake_address,
                            "TXOs not found for Stake Address in Assets Cache");
                        }
                    },
                );
                Op::Nop
            });
    }
}

/// Empty the TXO Assets cache.
pub(crate) fn drop() {
    ASSETS_CACHE.invalidate_all();
}

/// Size of TXO Assets cache.
pub(crate) fn size() -> u64 {
    ASSETS_CACHE.run_pending_tasks();
    ASSETS_CACHE.weighted_size()
}
/// Number of entries in TXO Assets cache.
pub(crate) fn entry_count() -> u64 {
    ASSETS_CACHE.run_pending_tasks();
    ASSETS_CACHE.entry_count()
}
