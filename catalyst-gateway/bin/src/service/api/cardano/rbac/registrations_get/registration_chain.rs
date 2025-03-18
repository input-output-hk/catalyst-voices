//! RBAC registration chain.

use std::collections::HashMap;

use c509_certificate::c509::C509;
use minicbor::{Encode, Encoder};
use poem_openapi::types::Example;
use poem_openapi_derive::Object;
use rbac_registration::{cardano::cip509::PointData, registration::cardano::RegistrationChain};
use x509_cert::certificate::Certificate as X509Certificate;

use crate::service::{
    api::cardano::rbac::registrations_get::{
        certificate_map::CertificateMap, purpose_list::PurposeList,
    },
    common::types::{cardano::catalyst_id::CatalystId, generic::uuidv4::UUIDv4},
};

/// A chain of valid RBAC registrations.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct RbacRegistrationChain {
    /// A Catalyst ID.
    catalyst_id: CatalystId,
    /// A list of registration purposes.
    #[oai(skip_serializing_if_is_empty)]
    purpose: PurposeList,
    /// A map of X509 certificates in the binary format.
    #[oai(skip_serializing_if_is_empty)]
    x509_certs: CertificateMap,
    /// A map of C509 certificates in the binary format.
    #[oai(skip_serializing_if_is_empty)]
    c509_certs: CertificateMap,
    // TODO: FIXME:
    // simple_keys: HashMap<usize, (PointTxnIdx, VerifyingKey)>,
    // revocations: Vec<(PointTxnIdx, CertKeyHash)>,
    // role_data: HashMap<RoleNumber, (PointTxnIdx, RoleData)>,
    // TODO: FIXME: Key rotation in role data!
}

impl Example for RbacRegistrationChain {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            purpose: PurposeList::example(),
            x509_certs: CertificateMap::example(),
            c509_certs: CertificateMap::example(),
        }
    }
}

impl From<RegistrationChain> for RbacRegistrationChain {
    fn from(chain: RegistrationChain) -> Self {
        let purpose = chain
            .purpose()
            .iter()
            .copied()
            .map(UUIDv4::from)
            .collect::<Vec<_>>()
            .into();
        let x509_certs = convert_x509_map(chain.x509_certs());
        let c509_certs = convert_c509_map(chain.c509_certs());

        Self {
            catalyst_id: chain.catalyst_id().clone().into(),
            purpose,
            x509_certs,
            c509_certs,
        }
    }
}

/// Converts X509 certificates.
fn convert_x509_map(
    certs: &HashMap<usize, Vec<PointData<Option<X509Certificate>>>>,
) -> CertificateMap {
    todo!()
}

/// Converts a map of C509 certificates.
fn convert_c509_map(certs: &HashMap<usize, Vec<PointData<Option<C509>>>>) -> CertificateMap {
    certs
        .iter()
        .map(|(index, point_data)| (*index, encode_c509_list(point_data)))
        .collect::<HashMap<_, _>>()
        .into()
}

/// Encodes the given list of C509 certificates.
fn encode_c509_list(certs: &Vec<PointData<Option<C509>>>) -> Vec<Option<Vec<u8>>> {
    certs
        .iter()
        .map(|point_data| {
            point_data
                .data()
                .as_ref()
                .map(|cert| {
                    let mut buffer = Vec::new();
                    let mut e = Encoder::new(&mut buffer);
                    cert.encode(&mut e, &mut ()).ok().map(|()| buffer)
                })
                .flatten()
        })
        .collect()
}
