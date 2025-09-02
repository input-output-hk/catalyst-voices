//! A key value for role data.

use poem_openapi_derive::Union;

use crate::service::api::cardano::rbac::registrations_get::{
    binary_data::HexEncodedBinaryData, pem::Pem,
};

/// A key value for role data.
#[derive(Union, Debug, Clone)]
pub enum KeyValue {
    /// A public key.
    Pubkey(Option<HexEncodedBinaryData>),
    /// A X509 certificate.
    X509(Option<Pem>),
    /// A C509 certificate.
    C509(Option<HexEncodedBinaryData>),
}
