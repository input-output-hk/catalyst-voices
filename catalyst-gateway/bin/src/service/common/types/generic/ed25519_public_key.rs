//! Ed25519 Public Key Type.
//!
//! Hex encoded string which represents an Ed25519 public key.

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::{service::common::types::string_types::impl_string_types, utils::ed25519};

/// Title.
const TITLE: &str = "Ed25519 Public Key";
/// Description.
const DESCRIPTION: &str = "This is a 32 Byte Hex encoded Ed25519 Public Key.";
/// Example.
const EXAMPLE: &str = "0x98dbd3d884068eee77e5894c22268d5d12e6484ba713e7ddd595abba308d88d3";
/// Length of the hex encoded string
const ENCODED_LENGTH: usize = ed25519::HEX_ENCODED_LENGTH;
/// Validation Regex Pattern
const PATTERN: &str = "0x[A-Fa-f0-9]{64}";

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
    "hex:ed25519-public-key",
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for Ed25519HexEncodedPublicKey {
    /// An example 32 bytes ED25519 Public Key.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl TryFrom<Vec<u8>> for Ed25519HexEncodedPublicKey {
    type Error = anyhow::Error;

    fn try_from(value: Vec<u8>) -> Result<Self, Self::Error> {
        let key = ed25519::verifying_key_from_vec(&value)?;

        Ok(Self(format!("0x{}", hex::encode(key))))
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
