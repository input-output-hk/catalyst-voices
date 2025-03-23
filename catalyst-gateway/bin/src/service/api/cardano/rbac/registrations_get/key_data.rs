//! A role data key information.

use chrono::{DateTime, Utc};
use poem_openapi::{types::Example, Object};
use rbac_registration::{
    cardano::cip509::{KeyLocalRef, LocalRefInt},
    registration::cardano::RegistrationChain,
};

use crate::service::common::types::generic::{
    boolean::BooleanFlag, date_time::DateTime as ServiceDateTime,
    ed25519_public_key::Ed25519HexEncodedPublicKey,
};

/// A role data key information.
///
/// Only one of the `pub_key`, `x509_cert` and `c509_cert` fields can be present at the
/// same time.
#[derive(Object, Debug, Clone)]
pub struct KeyData {
    /// Indicates if the data is persistent or volatile.
    is_persistent: BooleanFlag,
    /// A time when the address was added.
    time: ServiceDateTime,
    /// An ed25519 public key.
    pub_key: Option<Ed25519HexEncodedPublicKey>,
    // TODO: FIXME:
    x509_cert: Option<()>,
    // TODO: FIXME:
    c509_cert: Option<()>,
}

impl KeyData {
    /// Creates a new `KeyData` instance.
    pub fn new(
        is_persistent: bool, time: DateTime<Utc>, key_ref: Option<&KeyLocalRef>,
        chain: &RegistrationChain,
    ) -> Self {
        let mut pub_key = None;
        let mut x509_cert = None;
        let mut c509_cert = None;

        // TODO: FIXME:
        if let Some(key_ref) = key_ref {
            match key_ref.local_ref {
                LocalRefInt::X509Certs => {},
                LocalRefInt::C509Certs => {},
                LocalRefInt::PubKeys => {
                    let a = chain.simple_keys().get(&usize::from(key_ref.key_offset));
                },
            }
        }

        Self {
            is_persistent: is_persistent.into(),
            time: time.into(),
            pub_key,
            x509_cert,
            c509_cert,
        }
    }
}

impl Example for KeyData {
    fn example() -> Self {
        Self {
            is_persistent: BooleanFlag::example(),
            time: ServiceDateTime::example(),
            pub_key: Some(Ed25519HexEncodedPublicKey::example()),
            x509_cert: None,
            c509_cert: None,
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
