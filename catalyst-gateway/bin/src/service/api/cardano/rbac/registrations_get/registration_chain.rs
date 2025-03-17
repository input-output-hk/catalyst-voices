//! RBAC registration chain.

use std::collections::HashMap;

use poem_openapi::types::Example;
use poem_openapi_derive::Object;
use rbac_registration::registration::cardano::RegistrationChain;

use crate::service::{
    api::cardano::rbac::registrations_get::purpose_list::PurposeList,
    common::types::{
        cardano::catalyst_id::CatalystId, generic::uuidv4::UUIDv4, payload::cbor::Cbor,
    },
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
    x509_certs: HashMap<usize, Cbor<Vec<u8>>>,
    /// A map of C509 certificates in the binary format.
    #[oai(skip_serializing_if_is_empty)]
    c509_certs: HashMap<usize, Cbor<Vec<u8>>>,
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
            x509_certs: HashMap::new(),
            c509_certs: HashMap::new(),
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
        let x509_certs = chain
            .x509_certs()
            .into_iter()
            .map(|(index, (_, cert))| {
                //(index, cert.encode())
                // TODO: FIXME:
                (index, Vec::new())
            })
            .collect();
        let c509_certs = chain
            .c509_certs()
            .into_iter()
            .map(|(index, (_, cert))| {
                //(index, cert.encode())
                // TODO: FIXME:
                (index, Vec::new())
            })
            .collect();

        Self {
            catalyst_id: chain.catalyst_id().into(),
            purpose,
            x509_certs,
            c509_certs,
        }
    }
}
