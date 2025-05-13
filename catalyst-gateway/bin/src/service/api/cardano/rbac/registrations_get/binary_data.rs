//! A hex encoded binary data.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::{
    common::types::{
        generic::ed25519_public_key::Ed25519HexEncodedPublicKey, string_types::impl_string_types,
    },
    utilities::as_hex_string,
};

/// A title.
const TITLE: &str = "Hex encoded binary data";
/// A description.
const DESCRIPTION: &str = "A hex encoded binary data.";
/// An example.
const EXAMPLE: &str = "0x56CDD154355E078A0990F9E633F9553F7D43A68B2FF9BEF78B9F5C71C808A7C8";
/// A validation regex pattern.
const PATTERN: &str = "0x[A-Fa-f0-9]+$";
/// A format.
const FORMAT: &str = "hex";

/// A schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        pattern: Some(PATTERN.to_string()),
        ..MetaSchema::ANY
    }
});

/// Validate the `HexEncodedBinaryData`.
/// This part is done separately from the `PATTERN`
fn is_valid(hash: &str) -> bool {
    /// Regex to validate `HexEncodedBinaryData`
    #[allow(clippy::unwrap_used)] // Safe because the Regex is constant
    static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

    if RE.is_match(hash) {
        if let Some(h) = hash.strip_prefix("0x") {
            return hex::decode(h).is_ok();
        }
    }
    false
}

impl_string_types!(
    /// A hex encoded binary data.
    HexEncodedBinaryData,
    "string",
    FORMAT,
    Some(SCHEMA.clone()),
    is_valid
);

impl From<Vec<u8>> for HexEncodedBinaryData {
    fn from(value: Vec<u8>) -> Self {
        Self(as_hex_string(&value))
    }
}

impl From<Ed25519HexEncodedPublicKey> for HexEncodedBinaryData {
    fn from(value: Ed25519HexEncodedPublicKey) -> Self {
        Self(value.into())
    }
}

impl Example for HexEncodedBinaryData {
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hex_binary_data() {
        assert!(HexEncodedBinaryData::parse_from_parameter(EXAMPLE).is_ok());

        let invalid = ["123", "0x", "0xqw", "abcdefghijk"];
        for v in invalid {
            assert!(HexEncodedBinaryData::parse_from_parameter(v).is_err());
        }
    }
}
