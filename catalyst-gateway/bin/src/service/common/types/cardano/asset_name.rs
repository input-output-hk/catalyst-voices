//! Cardano Native Asset Name.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Title.
const TITLE: &str = "Cardano Native Asset Name";
/// Description.
const DESCRIPTION: &str = r"The name given to the native asset when it was minted.
It is used to distinguish different assets within the same policy.
If the name starts with 0x, it will be treated as hex encoded,
this hex encoded should not exceed 64 length long.
Otherwise, it will be treated as normal string, which will later be converted to UTF-8 where after converted, 
it should not exceed 32 bytes";

/// Example.
const EXAMPLE: &str = "My Cool\nAsset";
/// Minimum length.
const MIN_LENGTH: usize = 0;
/// Maximum length.
const MAX_LENGTH: usize = 1000;
/// Validation Regex Pattern
/// Can be anything
const PATTERN: &str = r".*";

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

// Validate `AssetName` This part is done separately from the `PATTERN`
fn is_valid(name: &str) -> bool {
    // Hex string
    if let Some(hash) = name.strip_prefix("0x") {
        hash.len() <= 64
    // Any string
    } else {
        let hex = hex::encode(name);
        hex.len() <= 64
    }
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
    use regex::Regex;

    use super::*;

    #[test]
    fn test_asset_name() {
        let regex = Regex::new(PATTERN).unwrap();

        // Test Data
        // <https://preprod.cardanoscan.io/tokens>
        let valid = [
            "This_Is_A_Very_Long_String______",
            "0x7dc6f84acd4016aa7b2f7ab7231981a1014fdcc0a1df70424a3e179b5e1c8e67",
            "SPLASH",
            "0x6c71",
            "",
        ];

        // Valid Regex, invalid parsing
        let invalid = [
            "0x40a8016ca43cfae6b76b11222042664b3b6f2fdcdb08c98ac9d51f41217922b41",
            "This_Is_A_Very_Long_String_but_invalid_parsing",
            "0x",
        ];

        for v in valid {
            assert!(regex.is_match(v));
            assert!(AssetName::parse_from_parameter(v).is_ok());
        }

        for v in invalid {
            assert!(regex.is_match(v));
            assert!(AssetName::parse_from_parameter(v).is_err());
        }
    }
}
