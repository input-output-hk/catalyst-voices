//! Signed Document Version
//!
//! `UUIDv7` Encoded Document Version.

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
const TITLE: &str = "Signed Document Version";
/// Description.
const DESCRIPTION: &str = "Unique [Document Version](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver).  

UUIDv7 Formatted 128bit value.";
/// Example.
const EXAMPLE: &str = "01944e87-e68c-7f22-9df1-816863cfa5ff";
/// Example - Range min.
const EXAMPLE_MAX: &str = "01944e87-e68c-7f22-9df1-000000000000";
/// Example.
const EXAMPLE_MIN: &str = "01944e87-e68c-7f22-9df1-ffffffffffff";
/// External Documentation URI
const URI: &str =
    "https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver";
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

impl_string_types!(
    DocumentVer,
    "string",
    FORMAT,
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for DocumentVer {
    /// An example.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl TryFrom<&str> for DocumentVer {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for DocumentVer {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        if !is_valid(&value) {
            bail!("Invalid DocumentID, must be a valid UUIDv7")
        }
        Ok(Self(value))
    }
}

impl From<uuidv7::UUIDv7> for DocumentVer {
    fn from(value: uuidv7::UUIDv7) -> Self {
        Self(value.to_string())
    }
}

#[derive(Object, Debug, PartialEq)]
#[oai(example = true)]
/// Version Range
pub(crate) struct VerRangeInner {
    /// Minimum Document Version to find (inclusive)
    min: DocumentVer,
    /// Maximum Document Version to find (inclusive)
    max: DocumentVer,
}

impl Example for VerRangeInner {
    fn example() -> Self {
        Self {
            min: DocumentVer(EXAMPLE_MIN.to_owned()),
            max: DocumentVer(EXAMPLE_MAX.to_owned()),
        }
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Version Range
///
/// A range of [Document Versions]().
pub(crate) struct VerRange(VerRangeInner);

impl Example for VerRange {
    fn example() -> Self {
        Self(VerRangeInner::example())
    }
}

#[derive(Union, Debug, PartialEq)]
#[oai(one_of)]
/// Document or Range of Documents
///
/// Either a Single Document Version, or a Range of Document Versions
pub(crate) enum EqOrRangedVerInner {
    /// This exact Document ID
    Eq(DocumentVer),
    /// Document Versions in this range
    Range(VerRange),
}

impl Example for EqOrRangedVerInner {
    fn example() -> Self {
        Self::Range(VerRange::example())
    }
}

#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document Version Selector
///
/// Either a absolute single Document Version or a range of Document Versions
pub(crate) struct EqOrRangedVer(EqOrRangedVerInner);

impl Example for EqOrRangedVer {
    fn example() -> Self {
        Self(EqOrRangedVerInner::example())
    }
}
