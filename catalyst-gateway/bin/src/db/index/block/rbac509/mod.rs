//! Index Role-Based Access Control (RBAC) Registration.

// TODO: FIXME:
#![allow(unused_imports)]

pub(crate) mod insert_catalyst_id_for_stake_address;
pub(crate) mod insert_catalyst_id_for_txn_id;
pub(crate) mod insert_rbac509;
pub(crate) mod insert_rbac509_invalid;

use std::sync::{Arc, LazyLock};

use c509_certificate::{
    c509::C509,
    extensions::{alt_name::GeneralNamesOrText, extension::ExtensionValue},
    general_names::general_name::{GeneralNameTypeRegistry, GeneralNameValue},
};
use cardano_blockchain_types::{MultiEraBlock, Slot, StakeAddress, TransactionHash, TxnIndex};
use catalyst_types::id_uri::IdUri;
use der_parser::{asn1_rs::oid, der::parse_der_sequence, Oid};
use moka::{policy::EvictionPolicy, sync::Cache};
use pallas::ledger::addresses::Address;
use rbac_registration::cardano::cip509::{
    C509Cert, Cip509, Cip509RbacMetadata, KeyLocalRef, LocalRefInt, RoleNumber, X509DerCert,
};
use scylla::Session;
use tracing::error;
use x509_cert::{
    certificate::{CertificateInner, Rfc5280},
    der::{oid::db::rfc5912::ID_CE_SUBJECT_ALT_NAME, Decode},
};

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    service::common::auth::rbac::role0_kid::Role0Kid,
    settings::cassandra_db::EnvVars,
    utils::blake2b_hash::blake2b_128,
};

/// Context-specific primitive type with tag number 6 (`raw_tag` 134) for
/// uniform resource identifier (URI) in the subject alternative name extension.
pub const SAN_URI: u8 = 134;

/// Subject Alternative Name OID
pub(crate) const SUBJECT_ALT_NAME_OID: Oid = oid!(2.5.29 .17);

/// A Catalyst ID by transaction ID cache.
static CATALYST_ID_BY_TXN_ID_CACHE: LazyLock<Cache<TransactionHash, IdUri>> = LazyLock::new(|| {
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
    /// Invalid RBAC Registration Data.
    invalid: Vec<insert_rbac509_invalid::Params>,
    /// Chain Root For Transaction ID Data captured during indexing.
    catalyst_id_for_txn_id: Vec<insert_catalyst_id_for_txn_id::Params>,
    /// Chain Root For Stake Address Data captured during indexing.
    catalyst_id_for_stake_address: Vec<insert_catalyst_id_for_stake_address::Params>,
}

impl Rbac509InsertQuery {
    /// Create new data set for RBAC 509 Registrations Insert Query Batch.
    pub(crate) fn new() -> Self {
        Rbac509InsertQuery {
            registrations: Vec::new(),
            invalid: Vec::new(),
            catalyst_id_for_txn_id: Vec::new(),
            catalyst_id_for_stake_address: Vec::new(),
        }
    }

    /// Prepare Batch of Insert RBAC 509 Registration Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<(SizedBatch, SizedBatch, SizedBatch, SizedBatch)> {
        Ok((
            insert_rbac509::Params::prepare_batch(session, cfg).await?,
            insert_rbac509_invalid::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_txn_id::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_stake_address::Params::prepare_batch(session, cfg).await?,
        ))
    }

    /// Index the RBAC 509 registrations in a transaction.
    pub(crate) async fn index(
        &mut self, session: &Arc<CassandraSession>, txn_hash: TransactionHash, index: TxnIndex,
        block: &MultiEraBlock,
    ) {
        let slot = block.slot();
        let cip509 = match Cip509::new(block, index, &[]) {
            Ok(Some(v)) => v,
            Ok(None) => {
                // Nothing to index.
                return;
            },
            Err(e) => {
                error!(
                    slot = ?slot,
                    index = ?index,
                    "Invalid RBAC Registration Metadata in transaction: {e:?}"
                );
                return;
            },
        };

        // This should never happen, but let's check anyway.
        if slot != cip509.origin().point().slot_or_default() {
            error!(
                "Cip509 slot mismatch: expected {slot:?}, got {:?}",
                cip509.origin().point().slot_or_default()
            );
        }
        if txn_hash != cip509.txn_hash() {
            error!(
                "Cip509 txn hash mismatch: expected {txn_hash}, got {}",
                cip509.txn_hash()
            );
        }

        let Some(catalyst_id) = catalyst_id(&cip509, txn_hash) else {
            error!("Unable to determine Catalyst id for registration: slot = {slot:?}, index = {index:?}, txn_hash = {txn_hash:?}");
            return;
        };

        let previous_transaction = cip509.previous_transaction();
        let purpose = cip509.purpose();
        match cip509.consume() {
            Ok((purpose, metadata, _)) => {
                self.registrations.push(insert_rbac509::Params::new(
                    catalyst_id.clone().into(),
                    txn_hash.into(),
                    slot.into(),
                    index.into(),
                    purpose.into(),
                    previous_transaction.map(Into::into),
                ));
                self.catalyst_id_for_txn_id
                    .push(insert_catalyst_id_for_txn_id::Params::new(
                        catalyst_id.clone().into(),
                        txn_hash.into(),
                        slot.into(),
                        index.into(),
                    ));
                for address in stake_addresses(&metadata) {
                    self.catalyst_id_for_stake_address.push(
                        insert_catalyst_id_for_stake_address::Params::new(
                            address,
                            slot.into(),
                            index.into(),
                            catalyst_id.clone().into(),
                        ),
                    );
                }
            },
            Err(report) => {
                self.invalid.push(insert_rbac509_invalid::Params::new(
                    catalyst_id.into(),
                    txn_hash.into(),
                    slot.into(),
                    index.into(),
                    purpose.map(Into::into),
                    previous_transaction.map(Into::into),
                    report,
                ));
            },
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

        if !self.invalid.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(PreparedQuery::Rbac509InvalidInsertQuery, self.invalid)
                    .await
            }));
        }

        if !self.catalyst_id_for_txn_id.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::CatalystIdForTxnIdInsertQuery,
                        self.catalyst_id_for_txn_id,
                    )
                    .await
            }));
        }

        if !self.catalyst_id_for_stake_address.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::CatalystIdForStakeAddressInsertQuery,
                        self.catalyst_id_for_stake_address,
                    )
                    .await
            }));
        }

        query_handles
    }
}

/// Returns a Catalyst ID of the given registration.
fn catalyst_id(cip509: &Cip509, txn_hash: TransactionHash) -> Option<IdUri> {
    let id = match cip509.previous_transaction() {
        Some(previous) => catalyst_id_from_tx(&previous)?,
        None => cip509.catalyst_id()?.as_short_id(),
    };

    CATALYST_ID_BY_TXN_ID_CACHE.insert(txn_hash, id.clone());
    Some(id)
}

/// Finds a Catalyst ID of the given transaction in the cache or database.
fn catalyst_id_from_tx(txn_hash: &TransactionHash) -> Option<IdUri> {
    if let Some(id) = CATALYST_ID_BY_TXN_ID_CACHE.get(txn_hash) {
        return Some(id);
    };

    // TODO: FIXME: Try to get from database.

    todo!()
}

// TODO: FIXME: Fix stake address type
fn stake_addresses(metadata: &Cip509RbacMetadata) -> Vec<StakeAddress> {
    let mut result = Vec::new();

    if let Some(uris) = metadata.certificate_uris.x_uris().get(&0) {
        result.extend(uris.into_iter().filter_map(|uri| {
            match uri.address() {
                Address::Stake(a) => Some(a.to_owned()),
                _ => None,
            }
        }));
    }
    if let Some(uris) = metadata.certificate_uris.c_uris().get(&0) {
        result.extend(uris.into_iter().filter_map(|uri| {
            match uri.address() {
                Address::Stake(a) => Some(a.to_owned()),
                _ => None,
            }
        }));
    }

    result
}

// /// Role0 Certificate Data.
// struct Role0CertificateData {
//     /// Role0 Key
//     role0_key: Role0Key,
//     /// Stake Addresses
//     stake_addresses: Option<Vec<StakeAddress>>,
// }

// /// Get Role0 X509 Certificate from `KeyReference`
// fn get_role0_x509_certs_from_reference(
//     x509_certs: Option<&Vec<X509DerCert>>, key_offset: Option<usize>,
// ) -> Option<(Role0Kid, x509_cert::Certificate)> {
//     x509_certs.and_then(|certs| {
//         key_offset.and_then(|pk_idx| {
//             certs.get(pk_idx).and_then(|cert| {
//                 match cert {
//                     X509DerCert::X509Cert(der_cert) => {
//                         match x509_cert::Certificate::from_der(der_cert) {
//                             Ok(decoded_cert) => {
//                                 let x = blake2b_128(&der_cert);
//                             },
//                             Err(err) => error!(err=%err,"Failed to decode Role0
// certificate."),                         }
//                     },
//                     X509DerCert::Deleted | X509DerCert::Undefined => None,
//                 }
//             })
//         })
//     })
// }
//
// /// Get Role0 C509 Certificate from `KeyReference`
// fn get_role0_c509_certs_from_reference(
//     c509_certs: Option<&Vec<C509Cert>>, key_offset: Option<usize>,
// ) -> Option<&C509> {
//     c509_certs.and_then(|certs| {
//         key_offset.and_then(|pk_idx| {
//             certs.get(pk_idx).and_then(|cert| {
//                 match cert {
//                     C509Cert::C509Certificate(cert) => Some(cert.as_ref()),
//                     // Currently C509CertInMetadatumReference is unsupported
//                     C509Cert::C509CertInMetadatumReference(_)
//                     | C509Cert::Undefined
//                     | C509Cert::Deleted => None,
//                 }
//             })
//         })
//     })
// }
//
// /// Extract Role0 Key from `KeyReference`
// fn extract_role0_data(
//     key_local_ref: &KeyLocalRef, rbac_metadata: &Cip509RbacMetadata,
// ) -> Option<Role0CertificateData> {
//     let key_offset: Option<usize> = key_local_ref.key_offset.try_into().ok();
//     match key_local_ref.local_ref {
//         LocalRefInt::X509Certs => {
//             get_role0_x509_certs_from_reference(rbac_metadata.x509_certs.as_ref(),
// key_offset)                 .and_then(|der_cert| {
//                     let cert = der_cert;
//                     let role0_key = der_cert
//                         .tbs_certificate
//                         .subject_public_key_info
//                         .subject_public_key
//                         .as_bytes()
//                         .map(<[u8]>::to_vec);
//
//                     role0_key.map(|role0_key| {
//                         let stake_addresses =
// extract_stake_addresses_from_x509(&der_cert);
// Role0CertificateData {                             role0_key,
//                             stake_addresses,
//                         }
//                     })
//                 })
//         },
//         LocalRefInt::C509Certs => {
//             get_role0_c509_certs_from_reference(rbac_metadata.c509_certs.as_ref(),
// key_offset).map(                 |cert| {
//                     let stake_addresses = extract_stake_addresses_from_c509(cert);
//                     Role0CertificateData {
//                         role0_key: cert.tbs_cert().subject_public_key().to_vec(),
//                         stake_addresses,
//                     }
//                 },
//             )
//         },
//         LocalRefInt::PubKeys => None, // Invalid for Role0 to have a simple key.
//     }
// }
//
// /// Extract Stake Address from X509 Certificate
// fn extract_stake_addresses_from_x509(
//     der_cert: &CertificateInner<Rfc5280>,
// ) -> Option<Vec<StakeAddress>> {
//     let mut stake_addresses = Vec::new();
//     // Find the Subject Alternative Name extension
//     let san_ext = der_cert
//         .tbs_certificate
//         .extensions
//         .as_ref()
//         .and_then(|exts| {
//             exts.iter()
//                 .find(|ext| ext.extn_id == ID_CE_SUBJECT_ALT_NAME)
//         });
//     // Subject Alternative Name extension if it exists
//     san_ext
//         .and_then(|san_ext| parse_der_sequence(san_ext.extn_value.as_bytes()).ok())
//         .and_then(|(_, parsed_seq)| {
//             for data in parsed_seq.ref_iter() {
//                 // Check for context-specific primitive type with tag number
//                 // 6 (raw_tag 134)
//                 if data.header.raw_tag() == Some(&[SAN_URI]) {
//                     if let Ok(content) = data.content.as_slice() {
//                         // Decode the UTF-8 string
//                         if let Some(addr) = std::str::from_utf8(content)
//                             .map(std::string::ToString::to_string)
//                             .ok()
//                             .and_then(|addr| extract_cip19_hash(&addr, Some("stake")))
//                         {
//                             stake_addresses.push(addr);
//                         }
//                     }
//                 }
//             }
//             if stake_addresses.is_empty() {
//                 None
//             } else {
//                 Some(stake_addresses)
//             }
//         })
// }
//
// /// Extract Stake Address from C509 Certificate
// fn extract_stake_addresses_from_c509(c509: &C509) -> Option<Vec<StakeAddress>> {
//     let mut stake_addresses = Vec::new();
//     for exts in c509.tbs_cert().extensions().extensions() {
//         if *exts.registered_oid().c509_oid().oid() == SUBJECT_ALT_NAME_OID {
//             if let ExtensionValue::AlternativeName(alt_name) = exts.value() {
//                 if let GeneralNamesOrText::GeneralNames(gn) = alt_name.general_name() {
//                     for name in gn.general_names() {
//                         if name.gn_type() ==
// &GeneralNameTypeRegistry::UniformResourceIdentifier {                             if
// let GeneralNameValue::Text(s) = name.gn_value() {                                 if
// let Some(h) = extract_cip19_hash(s, Some("stake")) {
// stake_addresses.push(h);                                 }
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//     }
//     if stake_addresses.is_empty() {
//         None
//     } else {
//         Some(stake_addresses)
//     }
// }

// /// Return RBAC metadata if its found in the transaction, or None
// async fn rbac_metadata(
//     session: &Arc<CassandraSession>, txn_hash: TransactionHash, txn_idx: usize,
// slot_no: u64,     block: &MultiEraBlock,
// ) -> Option<(Arc<Cip509>, ChainRoot)> {
//     if let Some(decoded_metadata) = block.txn_metadata(txn_idx, cip509::LABEL) {
//         if let Metadata::DecodedMetadataValues::Cip509(rbac) = &decoded_metadata.value
// {             if let Some(chain_root) =
//                 ChainRoot::get(session, txn_hash, txn_idx, slot_no, rbac).await
//             {
//                 return Some((rbac.clone(), chain_root));
//             }
//
//             // TODO: Maybe Index Invalid RBAC Registrations detected.
//             error!(
//                 slot = slot_no,
//                 txn_idx = txn_idx,
//                 "Invalid RBAC Registration Metadata in transaction."
//             );
//         }
//     }
//     None
// }
