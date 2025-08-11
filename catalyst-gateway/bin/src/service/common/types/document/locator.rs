//! Signed Document Locator
//!
//! `hex` Encoded Document Locator.

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Title.
const TITLE: &str = "Signed Document Locator";
/// Description.
const DESCRIPTION: &str = "Document Locator, encoded in hex string";
/// Example.
const EXAMPLE: &str = "0x";
/// Validation Regex Pattern
const PATTERN: &str = "^0x([0-9a-f]{2})*$";

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(value: &str) -> bool {
    value
        .strip_prefix("0x")
        .is_some_and(|hex| hex::decode(hex).is_ok())
}

impl_string_types!(
    DocumentLocator,
    "string",
    "hex",
    Some(MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(EXAMPLE.into()),
        max_length: Some(66),
        min_length: Some(2),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }),
    is_valid
);

impl Example for DocumentLocator {
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl From<catalyst_signed_doc::DocLocator> for DocumentLocator {
    fn from(value: catalyst_signed_doc::DocLocator) -> Self {
        Self(value.to_string())
    }
}
