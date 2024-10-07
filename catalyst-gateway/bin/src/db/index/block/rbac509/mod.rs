//! Index Role-Based Access Control (RBAC) Registration.

mod insert_chain_root_for_role0_key;
mod insert_chain_root_for_stake_address;
mod insert_chain_root_for_txn_id;
mod insert_rbac509;

use std::{
    convert::TryInto,
    sync::{Arc, LazyLock},
};

use c509_certificate::{
    c509::C509,
    extensions::{alt_name::GeneralNamesOrText, extension::ExtensionValue},
    general_names::general_name::{GeneralNameTypeRegistry, GeneralNameValue},
};
use cardano_chain_follower::{
    Metadata::{
        self,
        cip509::{
            rbac::{
                certs::{C509Cert, X509DerCert},
                pub_key::SimplePublicKeyType,
                role_data::{KeyReference, LocalRefInt},
                Cip509RbacMetadata,
            },
            utils::extract_cip19_hash,
        },
    },
    MultiEraBlock,
};
use der_parser::{asn1_rs::oid, der::parse_der_sequence, Oid};
use moka::{policy::EvictionPolicy, sync::Cache};
use scylla::Session;
use tracing::debug;
use x509_cert::{
    certificate::{CertificateInner, Rfc5280},
    der::{oid::db::rfc5912::ID_CE_SUBJECT_ALT_NAME, Decode},
};

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    settings::cassandra_db::EnvVars,
};

/// Context-specific primitive type with tag number 6 (`raw_tag` 134) for
/// uniform resource identifier (URI) in the subject alternative name extension.
pub const SAN_URI: u8 = 134;

/// Subject Alternative Name OID
pub(crate) const SUBJECT_ALT_NAME_OID: Oid = oid!(2.5.29 .17);

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
                // Skip processing if the following validations fail
                // if !(rbac.validation.valid_public_key
                //    && rbac.validation.valid_payment_key
                //    && rbac.validation.valid_txn_inputs_hash)
                //{
                //    return;
                //}
                let transaction_id = txn_hash.to_vec();

                let chain_root = rbac
                    .prv_tx_id
                    .as_ref()
                    .and_then(|tx_id| {
                        // Attempt to get Chain Root for the previous transaction ID.
                        debug!(prv_tx_id = hex::encode(tx_id), "RBAC looking for TX_ID");
                        CHAIN_ROOT_BY_TXN_ID_CACHE.get(&tx_id.to_vec()).or_else(|| {
                            // WIP: trace chain root by looking up previous transaction hashes from
                            // chain follower or DB
                            Some(tx_id.to_vec())
                        })
                    })
                    .or(Some(transaction_id.clone()));

                if let Some(chain_root) = chain_root {
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
                    let rbac_metadata = &rbac.x509_chunks.0;
                    if let Some(role_set) = &rbac_metadata.role_set {
                        for role in role_set.iter().filter(|role| role.role_number == 0) {
                            // Index Role 0 data
                            if let Some(Role0CertificateData {
                                role0_key,
                                stake_addresses,
                            }) = role.role_signing_key.as_ref().and_then(|key_reference| {
                                extract_role0_data(key_reference, rbac_metadata)
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
                                if let Some(stake_addresses) = stake_addresses {
                                    for stake_address in stake_addresses {
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
                } else {
                    tracing::debug!("Unable to get Chain Root for RBAC 509 registration");
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

/// Role0 Certificate Data.
struct Role0CertificateData {
    /// Role0 Key
    role0_key: Role0Key,
    /// Stake Addresses
    stake_addresses: Option<Vec<StakeAddress>>,
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

/// Extract Role0 Key from `KeyReference`
fn extract_role0_data(
    key_reference: &KeyReference, rbac_metadata: &Cip509RbacMetadata,
) -> Option<Role0CertificateData> {
    match key_reference {
        KeyReference::KeyHash(role0_key) => {
            Some(Role0CertificateData {
                role0_key: role0_key.clone(),
                stake_addresses: None,
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
                        let role0_key = der_cert
                            .tbs_certificate
                            .subject_public_key_info
                            .subject_public_key
                            .as_bytes()
                            .map(<[u8]>::to_vec);

                        role0_key.map(|role0_key| {
                            let stake_addresses = extract_stake_addresses_from_x509(&der_cert);
                            Role0CertificateData {
                                role0_key,
                                stake_addresses,
                            }
                        })
                    })
                },
                LocalRefInt::C509Certs => {
                    get_role0_c509_certs_from_reference(
                        rbac_metadata.c509_certs.as_ref(),
                        key_offset,
                    )
                    .map(|cert| {
                        let stake_addresses = extract_stake_addresses_from_c509(cert);
                        Role0CertificateData {
                            role0_key: cert.tbs_cert().subject_public_key().to_vec(),
                            stake_addresses,
                        }
                    })
                },
                LocalRefInt::PubKeys => {
                    key_offset.and_then(|pk_idx| {
                        rbac_metadata.pub_keys.as_ref().and_then(|keys| {
                            keys.get(pk_idx).and_then(|pk| {
                                match pk {
                                    SimplePublicKeyType::Ed25519(pk_bytes) => {
                                        Some(Role0CertificateData {
                                            role0_key: pk_bytes.to_vec(),
                                            stake_addresses: None,
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

/// Extract Stake Address from X509 Certificate
fn extract_stake_addresses_from_x509(
    der_cert: &CertificateInner<Rfc5280>,
) -> Option<Vec<StakeAddress>> {
    let mut stake_addresses = Vec::new();
    // Find the Subject Alternative Name extension
    let san_ext = der_cert
        .tbs_certificate
        .extensions
        .as_ref()
        .and_then(|exts| {
            exts.iter()
                .find(|ext| ext.extn_id == ID_CE_SUBJECT_ALT_NAME)
        });
    // Subject Alternative Name extension if it exists
    san_ext
        .and_then(|san_ext| parse_der_sequence(san_ext.extn_value.as_bytes()).ok())
        .and_then(|(_, parsed_seq)| {
            for data in parsed_seq.ref_iter() {
                // Check for context-specific primitive type with tag number
                // 6 (raw_tag 134)
                if data.header.raw_tag() == Some(&[SAN_URI]) {
                    if let Ok(content) = data.content.as_slice() {
                        // Decode the UTF-8 string
                        if let Some(addr) = std::str::from_utf8(content)
                            .map(std::string::ToString::to_string)
                            .ok()
                            .and_then(|addr| extract_cip19_hash(&addr, Some("stake")))
                        {
                            stake_addresses.push(addr);
                        }
                    }
                }
            }
            if stake_addresses.is_empty() {
                None
            } else {
                Some(stake_addresses)
            }
        })
}

/// Extract Stake Address from C509 Certificate
fn extract_stake_addresses_from_c509(c509: &C509) -> Option<Vec<StakeAddress>> {
    let mut stake_addresses = Vec::new();
    for exts in c509.tbs_cert().extensions().extensions() {
        if *exts.registered_oid().c509_oid().oid() == SUBJECT_ALT_NAME_OID {
            if let ExtensionValue::AlternativeName(alt_name) = exts.value() {
                if let GeneralNamesOrText::GeneralNames(gn) = alt_name.general_name() {
                    for name in gn.general_names() {
                        if name.gn_type() == &GeneralNameTypeRegistry::UniformResourceIdentifier {
                            if let GeneralNameValue::Text(s) = name.gn_value() {
                                if let Some(h) = extract_cip19_hash(s, Some("stake")) {
                                    stake_addresses.push(h);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if stake_addresses.is_empty() {
        None
    } else {
        Some(stake_addresses)
    }
}
