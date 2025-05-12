//! Hex encoded 28 byte hash.
//!
//! Hex encoded string which represents a 28 byte hash.

use std::sync::LazyLock;

use anyhow::bail;
use catalyst_types::hashes::BLAKE_2B224_SIZE;
use const_format::concatcp;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::{
    common::types::string_types::impl_string_types,
    utilities::{as_hex_string, from_hex_string},
};

/// Title.
const TITLE: &str = "28 Byte Hash";
/// Description.
const DESCRIPTION: &str = "This is a 28 Byte Hex encoded Hash.";
/// Example.
const EXAMPLE: &str = "0x8eee77e5894c22268d5d12e6484ba713e7ddd595abba308d88d36943";
/// Length of the hex encoded string;
const ENCODED_LENGTH: usize = EXAMPLE.len();
/// Length of the hash itself;
const HASH_LENGTH: usize = BLAKE_2B224_SIZE;
/// Validation Regex Pattern
const PATTERN: &str = concatcp!("^0x", "[A-Fa-f0-9]{", HASH_LENGTH * 2, "}$");

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

/// Validate `HexEncodedHash28` This part is done separately from the `PATTERN`
fn is_valid(hash: &str) -> bool {
    /// Regex to validate `HexEncodedHash28`
    #[allow(clippy::unwrap_used)] // Safe because the Regex is constant.
    static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

    if RE.is_match(hash) {
        if let Some(h) = hash.strip_prefix("0x") {
            return hex::decode(h).is_ok();
        }
    }
    false
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
        Ok(Self(as_hex_string(&value)))
    }
}

// Because it is impossible for the Encoded Hash to not be valid (due to `is_valid`), we
// can ensure this method is infallible.
// All creation of this type should come only from one of the deserialization methods.
impl From<HexEncodedHash28> for Vec<u8> {
    fn from(val: HexEncodedHash28) -> Self {
        #[allow(clippy::expect_used)]
        from_hex_string(&val.0).expect("This can only fail if the type was invalidly constructed.")
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hash_28() {
        assert!(HexEncodedHash28::parse_from_parameter(EXAMPLE).is_ok());

        let invalid = [
            "0x27d0350039fb3d068cccfae902bf2e72583fc5",
            "0x27d0350039fb3d068cccfae902bf2e72583fc553e0aafb960bd9d76d5bff777b0",
            "0x",
            "0xqw",
            "",
        ];
        for v in invalid {
            assert!(HexEncodedHash28::parse_from_parameter(v).is_err());
        }
    }
}
