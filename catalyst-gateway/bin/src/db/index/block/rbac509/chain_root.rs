//! Chain Root

use std::sync::{Arc, LazyLock};

use cardano_chain_follower::Metadata::cip509::Cip509;
use futures::StreamExt;
use moka::{policy::EvictionPolicy, sync::Cache};
use pallas::ledger::addresses::StakeAddress;
use pallas_crypto::hash::Hash;
use tracing::{error, warn};

use crate::{
    db::index::queries::rbac::get_chain_root, service::utilities::convert::big_uint_to_u64,
};

use super::CassandraSession;

/// Transaction Id Hash
type TransactionId = Hash<32>;

/// Chain Root Id - Hash of the first transaction in an RBAC Chain.
pub(crate) type ChainRootId = TransactionId;

/// The Chain Root for an RBAC Key Chain.
#[derive(Debug, Clone)]
pub(crate) struct ChainRoot {
    /// Transaction hash of the Chain Root itself
    pub txn_hash: ChainRootId,
    /// What slot# the Chain root is found in on the blockchain
    pub slot: u64,
    /// What transaction in the block holds the chain root.
    pub idx: i16,
}

/// Cached Chain Root By Transaction ID.
static CHAIN_ROOT_BY_TXN_ID_CACHE: LazyLock<Cache<TransactionId, ChainRoot>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Create the cache.
            .build()
    });

/*
/// Cached Chain Root By Role 0 Key.
static CHAIN_ROOT_BY_ROLE0_KEY_CACHE: LazyLock<Cache<Role0Key, ChainRoot>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Create the cache.
            .build()
    });
*/

/// Cached Chain Root By Stake Address.
static CHAIN_ROOT_BY_STAKE_ADDRESS_CACHE: LazyLock<Cache<StakeAddress, ChainRoot>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Create the cache.
            .build()
    });

impl ChainRoot {
    /// Create a new `ChainRoot` from the given Transaction and its metadata.
    pub(crate) async fn new(
        session: &Arc<CassandraSession>, txn_hash: Hash<32>, txn_index: i16, slot_no: u64,
        cip509: &Cip509,
    ) -> Option<ChainRoot> {
        if let Some(prv_tx_id) = cip509.prv_tx_id {
            let prv_tx_id: Hash<32> = prv_tx_id.into();
            match CHAIN_ROOT_BY_TXN_ID_CACHE.get(&prv_tx_id) {
                Some(chain_root) => Some(chain_root), // Cached
                None => {
                    // Not cached, need to see if its in the DB.
                    if let Ok(mut result) = get_chain_root::Query::execute(
                        session,
                        get_chain_root::QueryParams {
                            transaction_id: prv_tx_id.to_vec(),
                        },
                    )
                    .await
                    {
                        if let Some(row_res) = result.next().await {
                            let row = match row_res {
                                Ok(row) => row,
                                Err(err) => {
                                    error!(error = ?err, "Failed to parse get chain root by transaction id query row");
                                    return None;
                                },
                            };

                            let txn_hash = Hash::<32>::from(row.chain_root.as_slice());

                            let new_root = Self {
                                txn_hash,
                                slot: big_uint_to_u64(&row.slot_no),
                                idx: row.txn,
                            };

                            // Add the new Chain root to the cache.
                            CHAIN_ROOT_BY_TXN_ID_CACHE.insert(txn_hash, new_root.clone());

                            Some(new_root)
                        } else {
                            error!(prv_tx_id = ?prv_tx_id, "No data for chain root for prv_tx_id");
                            None
                        }
                    } else {
                        warn!(prev_txn_id=%prv_tx_id, "Chain root not found.");
                        None
                    }
                },
            }
        } else {
            let new_root = Self {
                txn_hash,
                idx: txn_index,
                slot: slot_no,
            };

            // Add the new Chain root to the cache.
            CHAIN_ROOT_BY_TXN_ID_CACHE.insert(txn_hash, new_root.clone());

            Some(new_root)
        }
    }

    /// Get ChainRoot for the given Stake Address.
    pub(crate) async fn for_stake_addr(stake: &StakeAddress) -> Option<Self> {
        match CHAIN_ROOT_BY_STAKE_ADDRESS_CACHE.get(stake) {
            Some(chain_root) => Some(chain_root),
            None => {
                // Look in DB for the stake registration
            },
        }
    }

    /// Update the cache when a rbac registration is indexed.
    pub(crate) fn cache_for_stake_addr(&self, stake: &StakeAddress) {
        CHAIN_ROOT_BY_STAKE_ADDRESS_CACHE.insert(stake.clone(), self.clone())
    }
}
