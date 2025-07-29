//! Signed Document Locator
//!
//! `hex` Encoded Document Locator.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use self::generic::uuidv7;
use crate::service::common::types::{generic, string_types::impl_string_types};

/// Title.
const TITLE: &str = "Signed Document Locator";
/// Description.
const DESCRIPTION: &str = "[Document Locator](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver).  

UUIDv7 Formatted 128bit value.";
/// Example.
const EXAMPLE: &str = "01944e87-e68c-7f22-9df1-816863cfa5ff";
/// External Documentation URI
const URI: &str =
    "https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver";
/// Description of the URI
const URI_DESCRIPTION: &str = "Specification";
/// Length of the hex encoded string
pub(crate) const ENCODED_LENGTH: usize = uuidv7::ENCODED_LENGTH;
/// Validation Regex Pattern
pub(crate) const PATTERN: &str = "^0x([0-9a-f]{2})*$";
/// Format
pub(crate) const FORMAT: &str = "hex";

/// Schema
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        max_length: Some(ENCODED_LENGTH),
        min_length: Some(ENCODED_LENGTH),
        pattern: Some(PATTERN.to_string()),
        external_docs: Some(MetaExternalDocument {
            url: URI.to_owned(),
            description: Some(URI_DESCRIPTION.to_owned()),
        }),

        ..poem_openapi::registry::MetaSchema::ANY
    }
});

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
    FORMAT,
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for DocumentLocator {
    /// An example.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl From<catalyst_signed_doc::DocLocator> for DocumentLocator {
    fn from(value: catalyst_signed_doc::DocLocator) -> Self {
        Self(value.to_string())
    }
}
