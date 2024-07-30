//! ED25519 public and private key implementation.

// cspell: words outpubkey genpkey

use std::{fmt::Display, path::Path, str::FromStr};

use ed25519_dalek::{
    ed25519::signature::Signer,
    pkcs8::{DecodePrivateKey, DecodePublicKey},
    SigningKey, VerifyingKey,
};
use wasm_bindgen::prelude::wasm_bindgen;

/// Public or private key decoding from string error.
#[derive(thiserror::Error, Debug)]
#[error("Cannot decode key from string. Invalid PEM format.")]
struct KeyPemDecodingError;

/// Ed25519 private key instance.
/// Wrapper over `ed25519_dalek::SigningKey`.
#[allow(dead_code)]
#[wasm_bindgen]
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct PrivateKey(SigningKey);

/// File open and read error.
#[derive(thiserror::Error, Debug)]
struct FileError {
    /// File location.
    location: String,
    /// File open and read error.
    msg: Option<anyhow::Error>,
}

#[allow(dead_code)]
impl FileError {
    /// Create a new `FileError` instance from a string location.
    fn from_string(location: String, msg: Option<anyhow::Error>) -> Self {
        Self { location, msg }
    }

    /// Create a new `FileError` instance from a path location.
    fn from_path<P: AsRef<Path>>(path: P, msg: Option<anyhow::Error>) -> Self {
        Self {
            location: path.as_ref().display().to_string(),
            msg,
        }
    }
}

impl Display for FileError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let msg = format!("Cannot open or read file at {0}", self.location);
        let err = self
            .msg
            .as_ref()
            .map(|msg| format!(":\n{msg}"))
            .unwrap_or_default();
        writeln!(f, "{msg}{err}",)
    }
}

#[allow(dead_code)]
impl PrivateKey {
    /// Create new public key from file decoded in PEM format.
    ///
    /// # Errors
    /// Returns an error if the file cannot be opened or read.
    pub fn from_file<P: AsRef<Path>>(path: P) -> anyhow::Result<Self> {
        let str = std::fs::read_to_string(&path).map_err(|_| FileError::from_path(&path, None))?;
        Ok(Self::from_str(&str).map_err(|err| FileError::from_path(&path, Some(err)))?)
    }

    /// Get associated public key.
    #[must_use]
    pub fn public_key(&self) -> PublicKey {
        PublicKey(self.0.verifying_key())
    }

    /// Sign the message with the current private key.
    /// Returns the signature bytes.
    #[must_use]
    pub fn sign(&self, msg: &[u8]) -> Vec<u8> {
        self.0.sign(msg).to_vec()
    }
}

impl FromStr for PrivateKey {
    type Err = anyhow::Error;

    fn from_str(str: &str) -> Result<Self, Self::Err> {
        let key = SigningKey::from_pkcs8_pem(str).map_err(|_| KeyPemDecodingError)?;
        Ok(Self(key))
    }
}

/// Ed25519 public key instance.
/// Wrapper over `ed25519_dalek::VerifyingKey`.
#[derive(Clone, Debug, PartialEq, Eq)]
#[wasm_bindgen]
pub struct PublicKey(VerifyingKey);

#[allow(dead_code)]
impl PublicKey {
    /// Create new public key from file decoded in PEM format.
    ///
    /// # Errors
    /// Returns an error if the file cannot be opened or read.
    pub fn from_file<P: AsRef<Path>>(path: P) -> anyhow::Result<Self> {
        let str = std::fs::read_to_string(&path).map_err(|_| FileError::from_path(&path, None))?;
        Ok(Self::from_str(&str).map_err(|err| FileError::from_path(&path, Some(err)))?)
    }

    /// Create new public key from raw bytes.
    ///
    /// # Errors
    /// Returns an error if the provided bytes are not a valid public key.
    pub fn from_bytes(bytes: &[u8]) -> anyhow::Result<Self> {
        let key = VerifyingKey::from_bytes(bytes.try_into()?)?;
        Ok(Self(key))
    }

    /// Convert public key to raw bytes.
    #[must_use]
    pub fn to_bytes(&self) -> Vec<u8> {
        self.0.to_bytes().to_vec()
    }

    /// Verify signature of the message with the current public key.
    ///
    /// # Errors
    /// Returns an error if the signature is invalid.
    pub fn verify(&self, msg: &[u8], signature_bytes: &[u8]) -> anyhow::Result<()> {
        let signature_bytes = signature_bytes.try_into().map_err(|_| {
            anyhow::anyhow!(
                "Invalid signature bytes size: expected {}, provided {}.",
                ed25519_dalek::Signature::BYTE_SIZE,
                signature_bytes.len()
            )
        })?;
        let signature = ed25519_dalek::Signature::from_bytes(signature_bytes);
        self.0.verify_strict(msg, &signature)?;
        Ok(())
    }
}

impl FromStr for PublicKey {
    type Err = anyhow::Error;

    fn from_str(str: &str) -> Result<Self, Self::Err> {
        let key = VerifyingKey::from_public_key_pem(str).map_err(|_| KeyPemDecodingError)?;
        Ok(Self(key))
    }
}

#[cfg(test)]
pub(crate) mod tests {
    use std::env::temp_dir;

    use super::*;

    /// An Ed25519 private key in PEM format.
    /// Generated with `openssl` tool:
    /// ```shell
    /// openssl genpkey -algorithm=ED25519 -out=private.pem -outpubkey=public.pem
    /// ```
    pub(crate) fn private_key_str() -> String {
        format!(
            "{}\n{}\n{}",
            "-----BEGIN PRIVATE KEY-----",
            "MC4CAQAwBQYDK2VwBCIEIP1iI3LF7h89yY6QZmhDp4Y5FmTQ4oasbz2lEiaqqTzV",
            "-----END PRIVATE KEY-----"
        )
    }

    /// An Ed25519 public key in PEM format.
    /// This public key is corresponding to the `private_key_str()` private key.
    /// Generated with `openssl` tool:
    /// ```shell
    /// openssl genpkey -algorithm=ED25519 -out=private.pem -outpubkey=public.pem
    /// ```
    pub(crate) fn public_key_str() -> String {
        format!(
            "{}\n{}\n{}",
            "-----BEGIN PUBLIC KEY-----",
            "MCowBQYDK2VwAyEAtFuCleJwHS28jUCT+ulLl5c1+MXhehhDz2SimOhmWaI=",
            "-----END PUBLIC KEY-----"
        )
    }

    #[test]
    fn private_key_from_file_test() {
        let dir = temp_dir();

        let private_key_path = dir.as_path().join("private.pem");
        std::fs::write(&private_key_path, private_key_str())
            .expect("Cannot create private.pem file");

        let _key =
            PrivateKey::from_file(private_key_path).expect("Cannot create private key from file");
    }

    #[test]
    fn public_private_key_test() {
        let private_key =
            PrivateKey::from_str(&private_key_str()).expect("Cannot create private key");
        let public_key = PublicKey::from_str(&public_key_str()).expect("Cannot create public key");

        assert_eq!(private_key.public_key(), public_key);
    }

    #[test]
    fn sign_test() {
        let private_key =
            PrivateKey::from_str(&private_key_str()).expect("Cannot create private key");
        let public_key = PublicKey::from_str(&public_key_str()).expect("Cannot create public key");

        let msg = b"test";

        let signature = private_key.sign(msg);
        assert!(public_key.verify(msg, &signature).is_ok());
        assert!(
            public_key.verify(b"corrupted", &signature).is_err(),
            "Provided msg is not actually signed."
        );
    }
}
