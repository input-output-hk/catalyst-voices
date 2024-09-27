//! Index Role-Based Access Control (RBAC) Registration.
#![allow(dead_code)]

mod insert_chain_root_for_role0_key;
mod insert_chain_root_for_stake_address;
mod insert_chain_root_for_txn_id;
mod insert_rbac509;

use std::sync::{Arc, LazyLock};

use cardano_chain_follower::{Metadata, MultiEraBlock};
use moka::{policy::EvictionPolicy, sync::Cache};
use scylla::Session;

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    settings::cassandra_db::EnvVars,
};

/// Transaction Id Hash
type TransactionIdHash = Vec<u8>;
/// Chain Root Hash
type ChainRootHash = TransactionIdHash;
/// Slot Number
type SlotNumber = u64;
/// TX Index
type TxIndex = i16;
/// Role 0 Key
type Role0Key = Vec<u8>;
/// Stake Address
type StakeAddress = Vec<u8>;
/// Cached Values for `Role0Key` lookups.
type Role0KeyValue = (ChainRootHash, SlotNumber, TxIndex);
/// Cached Values for `StakeAddress` lookups.
type StakeAddressValue = (ChainRootHash, SlotNumber, TxIndex);

/// Cached Chain Root By Transaction ID.
static CHAIN_ROOT_BY_TXN_ID_CACHE: LazyLock<Cache<TransactionIdHash, ChainRootHash>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Create the cache.
            .build()
    });
/// Cached Chain Root By Role 0 Key.
static CHAIN_ROOT_BY_ROLE0_KEY_CACHE: LazyLock<Cache<Role0Key, Role0KeyValue>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Create the cache.
            .build()
    });
/// Cached Chain Root By Stake Address.
static CHAIN_ROOT_BY_STAKE_ADDRESS_CACHE: LazyLock<Cache<StakeAddress, StakeAddressValue>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Create the cache.
            .build()
    });

/// Index RBAC 509 Registration Query Parameters
pub(crate) struct Rbac509InsertQuery {
    /// RBAC Registration Data captured during indexing.
    registrations: Vec<insert_rbac509::Params>,
    /// Chain Root For Transaction ID Data captured during indexing.
    chain_root_for_txn_id: Vec<insert_chain_root_for_txn_id::Params>,
    /// Chain Root For Role0 Key Data captured during indexing.
    chain_root_for_role0_key: Vec<insert_chain_root_for_role0_key::Params>,
    /// Chain Root For Stake Address Data captured during indexing.
    chain_root_for_stake_address: Vec<insert_chain_root_for_stake_address::Params>,
}

impl Rbac509InsertQuery {
    /// Create new data set for RBAC 509 Registrations Insert Query Batch.
    pub(crate) fn new() -> Self {
        Rbac509InsertQuery {
            registrations: Vec::new(),
            chain_root_for_txn_id: Vec::new(),
            chain_root_for_role0_key: Vec::new(),
            chain_root_for_stake_address: Vec::new(),
        }
    }

    /// Prepare Batch of Insert RBAC 509 Registration Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<(SizedBatch, SizedBatch, SizedBatch, SizedBatch)> {
        Ok((
            insert_rbac509::Params::prepare_batch(session, cfg).await?,
            insert_chain_root_for_txn_id::Params::prepare_batch(session, cfg).await?,
            insert_chain_root_for_role0_key::Params::prepare_batch(session, cfg).await?,
            insert_chain_root_for_stake_address::Params::prepare_batch(session, cfg).await?,
        ))
    }

    /// Index the RBAC 509 registrations in a transaction.
    pub(crate) fn index(
        &mut self, txn_hash: &[u8], txn: usize, txn_index: i16, slot_no: u64, block: &MultiEraBlock,
    ) {
        if let Some(decoded_metadata) = block.txn_metadata(txn, Metadata::cip509::LABEL) {
            #[allow(irrefutable_let_patterns)]
            if let Metadata::DecodedMetadataValues::Cip509(rbac) = &decoded_metadata.value {
                let transaction_id = txn_hash.to_vec();
                let chain_root_opt = if let Some(_tx_id) = rbac.prv_tx_id {
                    // Attempt to get Chain Root for the previous transaction ID.
                    CHAIN_ROOT_BY_TXN_ID_CACHE.get(&transaction_id).or({
                        // WIP: Attempt to get from DB
                        None
                    })
                } else {
                    let chain_root = transaction_id.clone();
                    Some(chain_root)
                };
                // WIP: Check for role0_key
                let role0_key_opt = {
                    // WIP
                    Some(&[])
                };
                // WIP: Check for stake_address
                let stake_address_opt = {
                    // WIP
                    Some(&[])
                };
                if let (Some(chain_root), Some(role0_key), Some(stake_address)) =
                    (chain_root_opt, role0_key_opt, stake_address_opt)
                {
                    self.registrations.push(insert_rbac509::Params::new(
                        &chain_root,
                        &transaction_id,
                        slot_no,
                        txn_index,
                        rbac,
                    ));

                    CHAIN_ROOT_BY_TXN_ID_CACHE.insert(transaction_id.clone(), chain_root.clone());
                    self.chain_root_for_txn_id
                        .push(insert_chain_root_for_txn_id::Params::new(
                            &transaction_id,
                            &chain_root,
                        ));

                    self.chain_root_for_role0_key.push(
                        insert_chain_root_for_role0_key::Params::new(
                            role0_key,
                            &chain_root,
                            slot_no,
                            txn_index,
                        ),
                    );

                    if !stake_address.is_empty() {
                        self.chain_root_for_stake_address.push(
                            insert_chain_root_for_stake_address::Params::new(
                                stake_address,
                                &chain_root,
                                slot_no,
                                txn_index,
                            ),
                        );
                    }
                }
            }
        }
    }

    /// Execute the RBAC 509 Registration Indexing Queries.
    ///
    /// Consumes the `self` and returns a vector of futures.
    pub(crate) fn execute(self, session: &Arc<CassandraSession>) -> FallibleQueryTasks {
        let mut query_handles: FallibleQueryTasks = Vec::new();

        if !self.registrations.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(PreparedQuery::Rbac509InsertQuery, self.registrations)
                    .await
            }));
        }

        if !self.chain_root_for_txn_id.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::ChainRootForTxnIdInsertQuery,
                        self.chain_root_for_txn_id,
                    )
                    .await
            }));
        }

        if !self.chain_root_for_role0_key.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::ChainRootForRole0KeyInsertQuery,
                        self.chain_root_for_role0_key,
                    )
                    .await
            }));
        }

        if !self.chain_root_for_stake_address.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::ChainRootForStakeAddressInsertQuery,
                        self.chain_root_for_stake_address,
                    )
                    .await
            }));
        }

        query_handles
    }
}
