//! Hex encoded 28 byte hash.
//!
//! Hex encoded string which represents a 28 byte hash.

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

use crate::service::common::types::string_types::impl_string_types;

/// Title.
const TITLE: &str = "28 Byte Hash";
/// Description.
const DESCRIPTION: &str = "This is a 28 Byte Hex encoded Hash.";
/// Example.
const EXAMPLE: &str = "0x8eee77e5894c22268d5d12e6484ba713e7ddd595abba308d88d36943";
/// Length of the hex encoded string;
const ENCODED_LENGTH: usize = EXAMPLE.len();
/// Length of the hash itself;
const HASH_LENGTH: usize = 28;
/// Validation Regex Pattern
const PATTERN: &str = "0x[A-Fa-f0-9]{56}";

/// Schema.
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
fn is_valid(hash: &str) -> bool {
    if hash.len() == ENCODED_LENGTH && hash.starts_with("0x") {
        #[allow(clippy::string_slice)] // 100% safe due to the above checks.
        let hash = &hash[2..];
        hex::decode(hash).is_ok()
    } else {
        false
    }
}

impl_string_types!(
    HexEncodedHash28,
    "string",
    "hex:hash(28)",
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for HexEncodedHash28 {
    /// An example 32 bytes ED25519 Public Key.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl TryFrom<Vec<u8>> for HexEncodedHash28 {
    type Error = anyhow::Error;

    fn try_from(value: Vec<u8>) -> Result<Self, Self::Error> {
        if value.len() != HASH_LENGTH {
            bail!("Hash Length Invalid.")
        }
        Ok(Self(format!("0x{}", hex::encode(value))))
    }
}

// Because it is impossible for the Encoded Hash to not be valid (due to `is_valid`), we
// can ensure this method is infallible.
// All creation of this type should come only from one of the deserialization methods.
impl From<HexEncodedHash28> for Vec<u8> {
    fn from(val: HexEncodedHash28) -> Self {
        #[allow(clippy::string_slice)] // 100% safe due to the way this type can be constructed.
        let raw_hex = &val.0[2..];
        #[allow(clippy::expect_used)]
        hex::decode(raw_hex).expect("This can only fail if the type was invalidly constructed.")
    }
}
