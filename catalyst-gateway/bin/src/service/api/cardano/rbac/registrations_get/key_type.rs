//! A key type for role data.

use poem_openapi::Enum;

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
