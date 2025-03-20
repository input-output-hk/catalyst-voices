//! RBAC registration chain.

use c509_certificate::c509::C509;
use cardano_blockchain_types::TransactionId;
use minicbor::{Encode, Encoder};
use poem_openapi::types::Example;
use poem_openapi_derive::Object;
use rbac_registration::{cardano::cip509::PointData, registration::cardano::RegistrationChain};
use x509_cert::{certificate::Certificate as X509Certificate, der::Encode as _};

use crate::service::{
    api::cardano::rbac::registrations_get::{
        certificate_map::CertificateMap, purpose_list::PurposeList, role_map::RoleMap,
    },
    common::types::{
        cardano::{catalyst_id::CatalystId, transaction_id::TxnId},
        generic::uuidv4::UUIDv4,
    },
};

/// A chain of valid RBAC registrations.
///
/// A unified data of multiple RBAC registrations.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct RbacRegistrationChain {
    /// A Catalyst ID.
    catalyst_id: CatalystId,
    /// An ID of the last persistent transaction.
    #[oai(skip_serializing_if_is_none)]
    last_persistent_txn_id: Option<TxnId>,
    /// An ID of the last volatile transaction.
    #[oai(skip_serializing_if_is_none)]
    last_volatile_txn_id: Option<TxnId>,
    /// A list of registration purposes.
    #[oai(skip_serializing_if_is_empty)]
    purpose: PurposeList,
    /// A map of roles.
    // This map is never empty, so there is no need to add the `skip_serializing_if_is_none`
    // attribute.
    roles: RoleMap,
}

impl Example for RbacRegistrationChain {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            purpose: PurposeList::example(),
            last_persistent_txn_id: Some(TxnId::example()),
            last_volatile_txn_id: Some(TxnId::example()),
            roles: RoleMap::example(),
        }
    }
}

impl RbacRegistrationChain {
    /// Creates a new registration chain instance.
    pub(crate) fn new(
        chain: RegistrationChain, persistent_id: Option<TransactionId>,
        volatile_id: Option<TransactionId>,
    ) -> Self {
        let catalyst_id = chain.catalyst_id().clone().into();
        let last_persistent_txn_id = persistent_id.map(Into::into);
        let last_volatile_txn_id = volatile_id.map(Into::into);
        let purpose = chain
            .purpose()
            .iter()
            .copied()
            .map(UUIDv4::from)
            .collect::<Vec<_>>()
            .into();
        let roles = RoleMap::new();

        Self {
            catalyst_id,
            last_persistent_txn_id,
            last_volatile_txn_id,
            purpose,
        }
    }
}

// TODO: FIXME:
// /// Converts X509 certificates.
// fn convert_x509_map(
//     certs: &HashMap<usize, Vec<PointData<Option<X509Certificate>>>>,
// ) -> CertificateMap {
//     certs
//         .iter()
//         .map(|(index, point_data)| (*index, encode_x509_list(point_data)))
//         .collect::<HashMap<_, _>>()
//         .into()
// }
//
// /// Encodes the given list of X509 certificates.
// fn encode_x509_list(certs: &Vec<PointData<Option<X509Certificate>>>) ->
// Vec<Option<Vec<u8>>> {     certs
//         .iter()
//         .map(|point_data| {
//             point_data
//                 .data()
//                 .as_ref()
//                 .map(|cert| {
//                     let mut buffer = Vec::new();
//                     let mut e = Encoder::new(&mut buffer);
//                     cert.encode(&mut e).ok().map(|()| buffer)
//                 })
//                 .flatten()
//         })
//         .collect()
// }
//
// /// Converts a map of C509 certificates.
// fn convert_c509_map(certs: &HashMap<usize, Vec<PointData<Option<C509>>>>) ->
// CertificateMap {     certs
//         .iter()
//         .map(|(index, point_data)| (*index, encode_c509_list(point_data)))
//         .collect::<HashMap<_, _>>()
//         .into()
// }
//
// /// Encodes the given list of C509 certificates.
// fn encode_c509_list(certs: &Vec<PointData<Option<C509>>>) -> Vec<Option<Vec<u8>>> {
//     certs
//         .iter()
//         .map(|point_data| {
//             point_data
//                 .data()
//                 .as_ref()
//                 .map(|cert| {
//                     let mut buffer = Vec::new();
//                     let mut e = Encoder::new(&mut buffer);
//                     cert.encode(&mut e, &mut ()).ok().map(|()| buffer)
//                 })
//                 .flatten()
//         })
//         .collect()
// }
