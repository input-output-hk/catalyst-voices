//! Utility functions for Ed25519 keys and crypto.

use anyhow::{bail, Error};

/// Length of the hex encoded string;
pub(crate) const HEX_ENCODED_LENGTH: usize = "0x".len() + (ed25519_dalek::PUBLIC_KEY_LENGTH * 2);

/// Convert a Vector of bytes into an ED25519 verifying key.
///
/// ## Errors
/// * The vector is not exactly 32 bytes
/// * the bytes do not encode a valid key
pub(crate) fn verifying_key_from_vec(bytes: &[u8]) -> Result<ed25519_dalek::VerifyingKey, Error> {
    let raw_key: [u8; ed25519_dalek::PUBLIC_KEY_LENGTH] = match bytes.try_into() {
        Ok(raw) => raw,
        Err(_) => {
            bail!("Invalid ED25519 Public Key length");
        },
    };
    let Ok(key) = ed25519_dalek::VerifyingKey::from_bytes(&raw_key) else {
        bail!("Invalid ED25519 Public Key")
    };
    Ok(key)
}

/// Convert a hex string to a Verifying Key.
pub(crate) fn verifying_key_from_hex(hex: &str) -> Result<ed25519_dalek::VerifyingKey, Error> {
    if hex.len() != HEX_ENCODED_LENGTH {
        anyhow::bail!("Invalid ED25519 Public Key Length");
    }
    if !hex.starts_with("0x") {
        anyhow::bail!("Does not start with required hex string prefix");
    }
    #[allow(clippy::string_slice)] // 100% safe due to the above length check.
    let raw_hex = &hex[2..];
    let raw_binary = hex::decode(raw_hex)?;
    verifying_key_from_vec(&raw_binary)
}
