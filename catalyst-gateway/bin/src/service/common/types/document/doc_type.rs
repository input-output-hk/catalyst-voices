//! Signed Document Type
//!
//! `UUIDv4` Encoded Document Type.

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use anyhow::bail;
use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use self::generic::uuidv4;
use crate::service::common::types::{generic, string_types::impl_string_types};

/// Title.
const TITLE: &str = "Signed Document Type";
/// Description.
const DESCRIPTION: &str = "Document Type.  UUIDv4 Formatted 128bit value.";
/// Example.
pub(crate) const EXAMPLE: &str = "7808d2ba-d511-40af-84e8-c0d1625fdfdc";
/// External Documentation URI
const URI: &str =
    "https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#type";
/// Description of the URI
const URI_DESCRIPTION: &str = "Specification";
/// Length of the hex encoded string
pub(crate) const ENCODED_LENGTH: usize = uuidv4::ENCODED_LENGTH;
/// Validation Regex Pattern
pub(crate) const PATTERN: &str = uuidv4::PATTERN;
/// Format
pub(crate) const FORMAT: &str = uuidv4::FORMAT;

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
fn is_valid(uuid: &str) -> bool {
    uuidv4::UUIDv4::try_from(uuid).is_ok()
}

impl_string_types!(
    DocumentType,
    "string",
    FORMAT,
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for DocumentType {
    /// An example.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl TryFrom<&str> for DocumentType {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for DocumentType {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        if !is_valid(&value) {
            bail!("Invalid DocumentType [{value}], must be a valid UUIDv4")
        }
        Ok(Self(value))
    }
}

impl From<uuidv4::UUIDv4> for DocumentType {
    fn from(value: uuidv4::UUIDv4) -> Self {
        Self(value.to_string())
    }
}
