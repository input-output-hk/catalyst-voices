//! Cache for TXO Assets by Stake Address Queries
use std::sync::{Arc, LazyLock};

use moka::{ops::compute::Op, policy::EvictionPolicy, sync::Cache};

use crate::{
    db::{
        index::queries::staked_ada::{
            get_txo_by_stake_address::GetTxoByStakeAddressQuery,
            update_txo_spent::UpdateTxoSpentQueryParams,
        },
        types::DbStakeAddress,
    },
    metrics::caches::txo_assets::{txo_assets_hits_inc, txo_assets_miss_inc},
    settings::Settings,
};

/// In memory cache of the most recent Cardano UTXO assets by Stake Address.
static ASSETS_CACHE: LazyLock<Cache<DbStakeAddress, Arc<Vec<GetTxoByStakeAddressQuery>>>> =
    LazyLock::new(|| {
        Cache::builder()
            .name("Cardano UTXO assets")
            .eviction_policy(EvictionPolicy::lru())
            .max_capacity(Settings::cardano_assets_cache().utxo_cache_size())
            .build()
    });

/// Get TXO Assets entry from Cache.
pub(crate) fn cache_get(
    stake_address: &DbStakeAddress,
) -> Option<Arc<Vec<GetTxoByStakeAddressQuery>>> {
    ASSETS_CACHE
        .get(stake_address)
        .inspect(|_| txo_assets_hits_inc())
        .or_else(|| {
            txo_assets_miss_inc();
            None
        })
}

/// Insert TXO Assets entry in Cache.
pub(crate) fn cache_insert(
    stake_address: DbStakeAddress, rows: Arc<Vec<GetTxoByStakeAddressQuery>>,
) {
    ASSETS_CACHE.insert(stake_address, rows);
}

/// Update spent UTXO Assets in Cache.
pub(crate) fn cache_update(params: Vec<UpdateTxoSpentQueryParams>) {
    for update in params {
        let stake_address = &update.stake_address;
        let _entry = ASSETS_CACHE
            .entry(stake_address.clone())
            .and_compute_with(|maybe_entry| {
                maybe_entry.map_or_else(|| {
                    tracing::debug!(utxo_params = ?update, stake_address = %stake_address, "Stake Address not found in Assets Cache");
                    Op::Nop
                }, |entry| {
                    if let Some(txo) = entry.into_value().iter().find(|t| {
                        t.key.txo == update.txo
                            && t.key.txn_index == update.txn_index
                            && t.key.slot_no == update.slot_no
                    }) {
                        let mut value = txo.value.write().unwrap_or_else(|error| {
                            tracing::error!(
                                ?update,
                                %stake_address,
                                %error,
                                "UTXO Assets Cache lock is poisoned, recovering lock.");
                            txo.value.clear_poison();
                            error.into_inner()

                        });
                        value.spent_slot = Some(update.spent_slot);
                        tracing::debug!(
                            ?update,
                            %stake_address,
                            "Updated UTXO for Stake Address in Assets Cache");
                    } else {
                        tracing::debug!(
                            ?update,
                            %stake_address,
                            "UTXOs not found for Stake Address in Assets Cache");
                    }
                    Op::Nop
                })
            });
    }
}

/// Empty the UTXO assets cache.
pub(crate) fn cache_drop() {
    ASSETS_CACHE.invalidate_all();
}
