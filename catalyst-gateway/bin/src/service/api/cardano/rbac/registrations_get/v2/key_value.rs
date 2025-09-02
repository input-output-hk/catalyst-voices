//! A key value for role data.

use poem_openapi::types::Example;
use poem_openapi_derive::{NewType, Union};

use crate::service::api::cardano::rbac::registrations_get::{
    binary_data::HexEncodedBinaryData, pem::Pem,
};

/// A key value for role data.
#[derive(Union, Debug, Clone)]
#[oai(one_of)]
pub enum KeyValue {
    /// A public key.
    Pubkey(Option<HexEncodedBinaryData>),
    /// A X509 certificate.
    X509(Option<Pem>),
    /// A C509 certificate.
    C509(Option<HexEncodedBinaryData>),
}

impl Example for KeyValue {
    fn example() -> Self {
        Self::Pubkey(Some(HexEncodedBinaryData::example()))
    }
}

/// A key value for role data.
#[derive(NewType, Debug, Clone)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub struct KeyValueWrapper(pub KeyValue);

impl Example for KeyValueWrapper {
    fn example() -> Self {
        Self(KeyValue::example())
    }
}
