//! Signed Document ID
//!
//! `UUIDv7` Encoded Document ID.

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use anyhow::bail;
use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
    NewType, Object, Union,
};
use serde_json::Value;

use self::generic::uuidv7;
use crate::service::common::types::{generic, string_types::impl_string_types};

/// Title.
const TITLE: &str = "Signed Document ID";
/// Description.
const DESCRIPTION: &str = "Unique [Document ID](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).

UUIDv7 Formatted 128bit value.";
/// Example.
const EXAMPLE: &str = "01944e87-e68c-7f22-9df1-816863cfa5ff";
/// External Documentation URI
const URI: &str =
    "https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id";
/// Description of the URI
const URI_DESCRIPTION: &str = "Specification";
/// Length of the hex encoded string
pub(crate) const ENCODED_LENGTH: usize = uuidv7::ENCODED_LENGTH;
/// Validation Regex Pattern
pub(crate) const PATTERN: &str = uuidv7::PATTERN;
/// Format
pub(crate) const FORMAT: &str = uuidv7::FORMAT;

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
    uuidv7::UUIDv7::try_from(uuid).is_ok()
}

impl_string_types!(DocumentId, "string", FORMAT, Some(SCHEMA.clone()), is_valid);

impl Example for DocumentId {
    /// An example.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl TryFrom<&str> for DocumentId {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for DocumentId {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        if !is_valid(&value) {
            bail!("Invalid DocumentID, must be a valid UUIDv7")
        }
        Ok(Self(value))
    }
}

impl From<uuidv7::UUIDv7> for DocumentId {
    fn from(value: uuidv7::UUIDv7) -> Self {
        Self(value.to_string())
    }
}

#[derive(Object, Debug, PartialEq)]
/// A range of Document IDs.
pub(crate) struct IdRangeInner {
    /// Minimum Document ID to find (inclusive)
    min: DocumentId,
    /// Maximum Document ID to find (inclusive)
    max: DocumentId,
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, PartialEq)]
#[oai(from_multipart = false, from_parameter = false, to_header = false)]
/// ID Range
///
/// A range of
/// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
pub(crate) struct IdRange(IdRangeInner);

#[derive(Union, Debug, PartialEq)]
#[oai(one_of)]
/// Either a Single Document ID, or a Range of Document IDs
pub(crate) enum EqOrRangedIdInner {
    /// This exact Document ID
    Eq(DocumentId),
    /// Document IDs in this range
    Range(IdRange),
}

impl Example for EqOrRangedIdInner {
    fn example() -> Self {
        Self::Eq(DocumentId::example())
    }
}

#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document ID Selector
///
/// Either a absolute single Document ID or a range of Document IDs
pub(crate) struct EqOrRangedId(EqOrRangedIdInner);

impl Example for EqOrRangedId {
    fn example() -> Self {
        Self(EqOrRangedIdInner::example())
    }
}
