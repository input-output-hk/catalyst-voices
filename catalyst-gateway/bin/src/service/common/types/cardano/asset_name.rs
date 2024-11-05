//! Hex encoded 28 byte hash.
//!
//! Hex encoded string which represents a 28 byte hash.

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
/// Minimum length.
const MIN_LENGTH: usize = 0;
/// Maximum length. (True length is 32, but escaping can double its size).
const MAX_LENGTH: usize = 64;
/// Validation Regex Pattern
const PATTERN: &str = r"[\S\s]{0,64}";

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

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(_name: &str) -> bool {
    // Anything is valid.
    true
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

// TODO: https://github.com/input-output-hk/catalyst-voices/issues/1121
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
