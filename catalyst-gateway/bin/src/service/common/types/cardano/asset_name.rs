//! Cardano Native Asset Name.

use std::sync::LazyLock;

use const_format::concatcp;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Title.
const TITLE: &str = "Cardano Native Asset Name";
/// Description.
const DESCRIPTION: &str = r"The name given to the native asset when it was minted.
If the name can be converted to UTF8, its string is represented directly.
Otherwise it will be represented as escaped ascii.
Any `\` present in the name will be replaced with `\\` in all cases.";

/// Example.
const EXAMPLE: &str = "My Cool\nAsset";
/// Maximum asset name in bytes.
const ASSET_NAME_MAX_BYTES: usize = 32;
/// Minimum length.
const MIN_LENGTH: usize = 0;
/// Maximum length calculated from maximum length of escaped string * max number of bytes
/// of asset name. <https://www.gnu.org/software/gawk/manual/html_node/Escape-Sequences.html>
const MAX_LENGTH: usize = ASSET_NAME_MAX_BYTES * 4;
/// Validation Regex Pattern
/// Can be anything
const PATTERN: &str = concatcp!("^.{", "0,", MAX_LENGTH, "}$");

/// Schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        max_length: Some(MAX_LENGTH),
        min_length: Some(MIN_LENGTH),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Validate `AssetName` This part is done separately from the `PATTERN`
fn is_valid(name: &str) -> bool {
    /// Regex to validate `AssetName`
    #[allow(clippy::unwrap_used)] // Safe because the Regex is constant.
    static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());
    RE.is_match(name)
}

impl_string_types!(
    AssetName,
    "string",
    "cardano:asset_name",
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for AssetName {
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl From<Vec<u8>> for AssetName {
    fn from(value: Vec<u8>) -> Self {
        match String::from_utf8(value.clone()) {
            Ok(name) => {
                // UTF8 - Yay
                // Escape any `\` so its consistent with escaped ascii below.
                let name = name.replace('\\', r"\\");
                Self(name)
            },
            Err(_) => Self(value.escape_ascii().to_string()),
        }
    }
}

impl From<String> for AssetName {
    fn from(value: String) -> Self {
        Self(value)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_asset_name() {
        let escape_octal = r"\nnn".repeat(32);
        // Test Data
        // <https://preprod.cardanoscan.io/tokens>
        let valid = ["This_Is_A_Very_Long_String______", &escape_octal, "SPLASH"];
        for v in valid {
            assert!(AssetName::parse_from_parameter(v).is_ok());
        }
        let invalid = [
            // Add additional char
            &format!("{escape_octal}a"),
        ];
        for v in invalid {
            assert!(AssetName::parse_from_parameter(v).is_err());
        }
    }
}
