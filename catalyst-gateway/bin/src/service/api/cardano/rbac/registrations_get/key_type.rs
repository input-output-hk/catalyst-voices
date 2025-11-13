//! A key type for role data.

use poem_openapi::{Enum, types::Example};
use poem_openapi_derive::NewType;

/// A key type for role data.
#[derive(Debug, Clone, Copy, Enum)]
#[oai(rename_all = "lowercase")]
pub enum KeyType {
    /// A public key.
    Pubkey,
    /// A X509 certificate.
    X509,
    /// A C509 certificate.
    C509,
}

impl Example for KeyType {
    fn example() -> Self {
        KeyType::X509
    }
}

// Note: this wrapper is needed for poem to properly generate example.
/// A key type for role data.
#[derive(Debug, Clone, Copy, NewType)]
#[oai(example = true, to_header = false)]
pub struct KeyTypeWrapper(pub KeyType);

impl Example for KeyTypeWrapper {
    fn example() -> Self {
        Self(KeyType::example())
    }
}
