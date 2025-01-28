//! Chain Root

use std::sync::{Arc, LazyLock};

use cardano_chain_follower::Metadata::cip509::Cip509;
use futures::StreamExt;
use moka::{policy::EvictionPolicy, sync::Cache};
use pallas::ledger::addresses::StakeAddress;
use pallas_crypto::hash::Hash;
use tracing::{error, warn};

use self::rbac::{
    get_chain_root_from_stake_addr::cache_for_stake_addr, get_role0_chain_root::cache_for_role0_kid,
};
use super::CassandraSession;
use crate::{
    db::index::{
        block::from_saturating,
        queries::rbac::{self, get_chain_root},
    },
    service::{common::auth::rbac::role0_kid::Role0Kid, utilities::convert::big_uint_to_u64},
};

/// Chain Root Id - Hash of the first transaction in an RBAC Chain.
pub(crate) type ChainRootId = TransactionHash;

/// The Chain Root for an RBAC Key Chain.
#[derive(Debug, Clone)]
pub(crate) struct ChainRoot {
    /// Transaction hash of the Chain Root itself
    pub txn_hash: ChainRootId,
    /// What slot# the Chain root is found in on the blockchain
    pub slot: u64,
    /// What transaction in the block holds the chain root.
    pub idx: usize,
}

pub(crate) const LRU_MAX_CAPACITY: usize = 1024;

/// Cached Chain Root By Transaction ID.
static CHAIN_ROOT_BY_TXN_HASH_CACHE: LazyLock<Cache<TransactionHash, ChainRoot>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Set the initial capacity
            .initial_capacity(LRU_MAX_CAPACITY)
            // Set the maximum number of LRU entries
            .max_capacity(LRU_MAX_CAPACITY as u64)
            // Create the cache.
            .build()
    });

impl ChainRoot {
    /// Create a new ChainRoot record
    pub(crate) fn new(chain_root: TransactionHash, slot_no: u64, txn_idx: usize) -> Self {
        Self {
            txn_hash: chain_root,
            slot: slot_no,
            idx: txn_idx,
        }
    }

    /// Gets a new `ChainRoot` from the given Transaction and its metadata.
    ///
    /// Will try and get it from the cache first, and fall back to the Index DB if not
    /// found.
    pub(crate) async fn get(
        session: &Arc<CassandraSession>, txn_hash: Hash<32>, txn_index: usize, slot_no: u64,
        cip509: &Cip509,
    ) -> Option<ChainRoot> {
        if let Some(prv_tx_id) = cip509.cip509.prv_tx_id {
            match CHAIN_ROOT_BY_TXN_HASH_CACHE.get(&prv_tx_id) {
                Some(chain_root) => Some(chain_root), // Cached
                None => {
                    // Not cached, need to see if its in the DB.
                    if let Ok(mut result) =
                        get_chain_root::Query::execute(session, get_chain_root::QueryParams {
                            transaction_id: prv_tx_id.to_vec(),
                        })
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
                                idx: from_saturating(row.txn),
                            };

                            // Add the new Chain root to the cache.
                            CHAIN_ROOT_BY_TXN_HASH_CACHE.insert(txn_hash, new_root.clone());

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
            CHAIN_ROOT_BY_TXN_HASH_CACHE.insert(txn_hash, new_root.clone());

            Some(new_root)
        }
    }

    /// Update the cache when a rbac registration is indexed.
    pub(crate) fn cache_for_stake_addr(&self, stake: &StakeAddress) {
        cache_for_stake_addr(stake, self);
    }

    /// Update the cache when a rbac registration is indexed.
    pub(crate) fn cache_for_role0_kid(&self, kid: Role0Kid) {
        cache_for_role0_kid(kid, self);
    }
}
