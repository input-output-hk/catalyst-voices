//! A key value for role data.

use poem_openapi::types::Example;
use poem_openapi_derive::{Object, Union};

use crate::service::{
    api::cardano::rbac::registrations_get::{pem::Pem, v2::c509::HexEncodedC509},
    common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
};

/// A key value for role data.
#[derive(Union, Debug, Clone)]
#[oai(one_of)]
pub enum KeyValue {
    /// A public key.
    Pubkey(PubkeyHex),
    /// A X509 certificate.
    X509(X509Pem),
    /// A C509 certificate.
    C509(C509Hex),
}

impl From<Ed25519HexEncodedPublicKey> for KeyValue {
    fn from(pubkey: Ed25519HexEncodedPublicKey) -> Self {
        Self::Pubkey(PubkeyHex { pubkey })
    }
}

impl From<Pem> for KeyValue {
    fn from(x509: Pem) -> Self {
        Self::X509(X509Pem { x509 })
    }
}

impl From<HexEncodedC509> for KeyValue {
    fn from(c509: HexEncodedC509) -> Self {
        Self::C509(C509Hex { c509 })
    }
}

impl Example for KeyValue {
    fn example() -> Self {
        KeyValue::Pubkey(PubkeyHex::example())
    }
}

/// A hex encoded public key.
#[derive(Object, Debug, Clone)]
pub struct PubkeyHex {
    /// A hex encoded public key.
    pubkey: Ed25519HexEncodedPublicKey,
}

impl Example for PubkeyHex {
    fn example() -> Self {
        Self {
            pubkey: Ed25519HexEncodedPublicKey::example(),
        }
    }
}

/// A PEM encoded X509 certificate.
#[derive(Object, Debug, Clone)]
pub struct X509Pem {
    /// A PEM encoded X509 certificate.
    x509: Pem,
}

/// A hex encoded C509 certificate.
#[derive(Object, Debug, Clone)]
pub struct C509Hex {
    /// A hex encoded C509 certificate.
    c509: HexEncodedC509,
}
