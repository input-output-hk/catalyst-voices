//! Index Role-Based Access Control (RBAC) Registration.

mod insert_chain_root_for_role0_key;
mod insert_chain_root_for_stake_address;
mod insert_chain_root_for_txn_id;
mod insert_rbac509;

use std::{
    convert::TryInto,
    sync::{Arc, LazyLock},
};

use c509_certificate::c509::C509;
use cardano_chain_follower::{
    Metadata::{
        self,
        cip509::rbac::{
            certs::{C509Cert, X509DerCert},
            pub_key::SimplePublicKeyType,
            role_data::{KeyReference, LocalRefInt},
            Cip509RbacMetadata,
        },
    },
    MultiEraBlock,
};
use moka::{policy::EvictionPolicy, sync::Cache};
use scylla::Session;
use x509_cert::der::Decode;

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
#[allow(dead_code)]
type SlotNumber = u64;
/// TX Index
#[allow(dead_code)]
type TxIndex = i16;
/// Role 0 Key
#[allow(dead_code)]
type Role0Key = Vec<u8>;
/// Stake Address
#[allow(dead_code)]
type StakeAddress = Vec<u8>;
/// Cached Values for `Role0Key` lookups.
#[allow(dead_code)]
type Role0KeyValue = (ChainRootHash, SlotNumber, TxIndex);
/// Cached Values for `StakeAddress` lookups.
#[allow(dead_code)]
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
#[allow(dead_code)]
static CHAIN_ROOT_BY_ROLE0_KEY_CACHE: LazyLock<Cache<Role0Key, Role0KeyValue>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Create the cache.
            .build()
    });
/// Cached Chain Root By Stake Address.
#[allow(dead_code)]
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
                // Skip processing if the following validations fail
                if !(rbac.validation.valid_public_key
                    && rbac.validation.valid_payment_key
                    && rbac.validation.valid_txn_inputs_hash)
                {
                    return;
                }
                let transaction_id = txn_hash.to_vec();

                let chain_root = if let Some(_tx_id) = rbac.prv_tx_id {
                    // Attempt to get Chain Root for the previous transaction ID.
                    CHAIN_ROOT_BY_TXN_ID_CACHE.get(&transaction_id).or({
                        // WIP: Attempt to get from DB
                        None
                    })
                } else {
                    let chain_root = transaction_id.clone();
                    Some(chain_root)
                };

                if let Some(chain_root) = chain_root {
                    let rbac_metadata = &rbac.x509_chunks.0;
                    if let Some(role_set) = &rbac_metadata.role_set {
                        for role in role_set.iter().filter(|role| role.role_number == 0) {
                            self.registrations.push(insert_rbac509::Params::new(
                                &chain_root,
                                &transaction_id,
                                slot_no,
                                txn_index,
                                rbac,
                            ));

                            CHAIN_ROOT_BY_TXN_ID_CACHE
                                .insert(transaction_id.clone(), chain_root.clone());
                            self.chain_root_for_txn_id.push(
                                insert_chain_root_for_txn_id::Params::new(
                                    &transaction_id,
                                    &chain_root,
                                ),
                            );
                            // Index Role 0 data
                            if let Some(Role0Data {
                                role0_key,
                                stake_address,
                            }) = role.role_signing_key.as_ref().and_then(|key_reference| {
                                get_role0_data(key_reference, rbac_metadata)
                            }) {
                                CHAIN_ROOT_BY_ROLE0_KEY_CACHE.insert(
                                    role0_key.clone(),
                                    (chain_root.clone(), slot_no, txn_index),
                                );
                                self.chain_root_for_role0_key.push(
                                    insert_chain_root_for_role0_key::Params::new(
                                        &role0_key,
                                        &chain_root,
                                        slot_no,
                                        txn_index,
                                    ),
                                );
                                if let Some(stake_address) = stake_address {
                                    CHAIN_ROOT_BY_STAKE_ADDRESS_CACHE.insert(
                                        stake_address.clone(),
                                        (chain_root.clone(), slot_no, txn_index),
                                    );
                                    self.chain_root_for_stake_address.push(
                                        insert_chain_root_for_stake_address::Params::new(
                                            &stake_address,
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

/// Role0 Data.
struct Role0Data {
    /// Role0 Key
    role0_key: Vec<u8>,
    /// Stake Address
    stake_address: Option<Vec<u8>>,
}

/// Get Role0 X509 Certificate from `KeyReference`
fn get_role0_x509_certs_from_reference(
    x509_certs: Option<&Vec<X509DerCert>>, key_offset: Option<usize>,
) -> Option<x509_cert::Certificate> {
    x509_certs.and_then(|certs| {
        key_offset.and_then(|pk_idx| {
            certs
                .get(pk_idx)
                .and_then(|cert| x509_cert::Certificate::from_der(&cert.0).ok())
        })
    })
}

/// Get Role0 C509 Certificate from `KeyReference`
fn get_role0_c509_certs_from_reference(
    c509_certs: Option<&Vec<C509Cert>>, key_offset: Option<usize>,
) -> Option<&C509> {
    c509_certs.and_then(|certs| {
        key_offset.and_then(|pk_idx| {
            certs.get(pk_idx).and_then(|cert| {
                match cert {
                    C509Cert::C509Certificate(cert) => Some(cert.as_ref()),
                    C509Cert::C509CertInMetadatumReference(_) => None,
                }
            })
        })
    })
}

/// Get Role0 Key from `KeyReference`
fn get_role0_data(
    key_reference: &KeyReference, rbac_metadata: &Cip509RbacMetadata,
) -> Option<Role0Data> {
    match key_reference {
        KeyReference::KeyHash(role0_key) => {
            Some(Role0Data {
                role0_key: role0_key.clone(),
                stake_address: None,
            })
        },
        KeyReference::KeyLocalRef(key_local_ref) => {
            let key_offset: Option<usize> = key_local_ref.key_offset.try_into().ok();
            match key_local_ref.local_ref {
                LocalRefInt::X509Certs => {
                    get_role0_x509_certs_from_reference(
                        rbac_metadata.x509_certs.as_ref(),
                        key_offset,
                    )
                    .and_then(|der_cert| {
                        der_cert
                            .tbs_certificate
                            .subject_public_key_info
                            .subject_public_key
                            .as_bytes()
                            .map(<[u8]>::to_vec)
                    })
                    .map(|role0_key| {
                        // WIP: Get stake address from cert
                        let stake_address = None;
                        Role0Data {
                            role0_key,
                            stake_address,
                        }
                    })
                },
                LocalRefInt::C509Certs => {
                    get_role0_c509_certs_from_reference(
                        rbac_metadata.c509_certs.as_ref(),
                        key_offset,
                    )
                    .map(|cert| {
                        // WIP: Get stake address from cert
                        let stake_address = None;
                        Role0Data {
                            role0_key: cert.get_tbs_cert().get_subject_public_key().to_vec(),
                            stake_address,
                        }
                    })
                },
                LocalRefInt::PubKeys => {
                    key_offset.and_then(|pk_idx| {
                        rbac_metadata.pub_keys.as_ref().and_then(|keys| {
                            keys.get(pk_idx).and_then(|pk| {
                                match pk {
                                    SimplePublicKeyType::Ed25519(pk_bytes) => {
                                        Some(Role0Data {
                                            role0_key: pk_bytes.to_vec(),
                                            stake_address: None,
                                        })
                                    },
                                    _ => None,
                                }
                            })
                        })
                    })
                },
            }
        },
    }
}
