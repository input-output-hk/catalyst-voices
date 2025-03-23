//! A role data.

use std::collections::HashMap;

use cardano_blockchain_types::Slot;
use poem_openapi::{types::Example, Object};
use rbac_registration::cardano::cip509::{PointData, RoleData};

use crate::{
    service::api::cardano::rbac::registrations_get::{
        key_data::KeyData, payment_data::PaymentData,
    },
    settings::Settings,
};

/// A role data.
#[derive(Object, Debug, Clone)]
pub struct RbacRoleData {
    /// A list of role signing keys.
    #[oai(skip_serializing_if_is_empty)]
    signing_keys: Vec<KeyData>,
    /// A list of role encryption keys.
    #[oai(skip_serializing_if_is_empty)]
    encryption_keys: Vec<KeyData>,
    /// A list of role payment addresses.
    #[oai(skip_serializing_if_is_empty)]
    payment_address: Vec<PaymentData>,
    /// A map of the extended data.
    ///
    /// Unlike other fields, we don't track history for this data.
    #[oai(skip_serializing_if_is_empty)]
    extended_data: HashMap<u8, Vec<u8>>,
}

impl RbacRoleData {
    pub fn new(point_data: &Vec<PointData<RoleData>>, last_persistent_slot: Slot) -> Self {
        let network = Settings::cardano_network();

        let mut signing_keys = Vec::new();
        let mut encryption_keys = Vec::new();
        let mut payment_address = Vec::new();
        let mut extended_data = HashMap::new();

        for point in point_data.iter() {
            let slot = point.point().slot_or_default();
            let is_persistent = slot <= last_persistent_slot;
            let time = network.slot_to_time(slot);
            let data = point.data();

            signing_keys.push(KeyData::new(is_persistent, time, data.signing_key()));
            encryption_keys.push(KeyData::new(is_persistent, time, data.encryption_key()));
            payment_address.push(PaymentData::new(
                is_persistent,
                time,
                data.payment_key().cloned(),
            ));
            extended_data.extend(data.extended_data().clone().into_iter());
        }

        Self {
            signing_keys,
            encryption_keys,
            payment_address,
            extended_data,
        }
    }
}

impl Example for RbacRoleData {
    fn example() -> Self {
        Self {
            signing_keys: vec![KeyData::example()],
            encryption_keys: vec![],
            payment_address: vec![PaymentData::example()],
            extended_data: Default::default(),
        }
    }
}

// TODO: FIXME:
//
// use x509_cert::{certificate::Certificate as X509Certificate, der::Encode as _};
//
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
