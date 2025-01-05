//! Ed25519 Public Key Type.
//!
//! Hex encoded string which represents an Ed25519 public key.

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use anyhow::bail;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::{
    service::{common::types::string_types::impl_string_types, utilities::as_hex_string},
    utils::ed25519,
};

/// Title.
const TITLE: &str = "Ed25519 Public Key";
/// Description.
const DESCRIPTION: &str = "This is a 32 Byte Hex encoded Ed25519 Public Key.";
/// Example.
const EXAMPLE: &str = "0x56CDD154355E078A0990F9E633F9553F7D43A68B2FF9BEF78B9F5C71C808A7C8";
/// Length of the hex encoded string
pub(crate) const ENCODED_LENGTH: usize = ed25519::HEX_ENCODED_LENGTH;
/// Validation Regex Pattern
pub(crate) const PATTERN: &str = "0x[A-Fa-f0-9]{64}";
/// Format
pub(crate) const FORMAT: &str = "hex:ed25519-public-key";

/// Schema
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        max_length: Some(ENCODED_LENGTH),
        min_length: Some(ENCODED_LENGTH),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(hex_key: &str) -> bool {
    // Just check the string can be safely converted into the type.
    // All the necessary validation is done in that process.
    ed25519::verifying_key_from_hex(hex_key).is_ok()
}

impl_string_types!(
    Ed25519HexEncodedPublicKey,
    "string",
    FORMAT,
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for Ed25519HexEncodedPublicKey {
    /// An example 32 bytes ED25519 Public Key.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl Ed25519HexEncodedPublicKey {
    /// Extra examples of 32 bytes ED25519 Public Key.
    pub(crate) fn examples(index: usize) -> Self {
        match index {
            0 => {
                Self(
                    "0xDEF855AE45F3BF9640A5298A38B97617DE75600F796F17579BFB815543624B24".to_owned(),
                )
            },
            1 => {
                Self(
                    "0x83B3B55589797EF953E24F4F0DBEE4D50B6363BCF041D15F6DBD33E014E54711".to_owned(),
                )
            },
            _ => {
                Self(
                    "0xA3E52361AFDE840918E2589DBAB9967C8027FB4431E83D36E338748CD6E3F820".to_owned(),
                )
            },
        }
    }
}

impl TryFrom<&str> for Ed25519HexEncodedPublicKey {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for Ed25519HexEncodedPublicKey {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        if !is_valid(&value) {
            bail!("Invalid Ed25519 Public key")
        }
        Ok(Self(value))
    }
}

impl TryFrom<Vec<u8>> for Ed25519HexEncodedPublicKey {
    type Error = anyhow::Error;

    fn try_from(value: Vec<u8>) -> Result<Self, Self::Error> {
        let key = ed25519::verifying_key_from_vec(&value)?;

        Ok(Self(as_hex_string(key.as_ref())))
    }
}

// Because it is impossible for the Encoded Key to not be a valid Verifying Key, we can
// ensure this method is infallible.
// All creation of this type should come from TryFrom<Vec<u8>>, or one of the
// deserialization methods.
impl From<Ed25519HexEncodedPublicKey> for ed25519_dalek::VerifyingKey {
    fn from(val: Ed25519HexEncodedPublicKey) -> Self {
        #[allow(clippy::expect_used)]
        ed25519::verifying_key_from_hex(&val.0)
            .expect("This can only fail if the type was invalidly constructed.")
    }
}

#[cfg(test)]
mod tests {
    use super::Ed25519HexEncodedPublicKey;

    #[test]
    fn hex_to_pub_key() {
        assert!(Ed25519HexEncodedPublicKey::try_from(
            "0x76e7ac0e460b6cdecea4be70479dab13c4adbd117421259a9b36caac007394de".to_string(),
        )
        .is_ok());
    }
}
