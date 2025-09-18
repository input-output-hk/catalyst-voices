//! Signed Document Version
//!
//! `UUIDv7` Encoded Document Version.

use std::sync::LazyLock;

use anyhow::bail;
use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use self::generic::uuidv7;
use crate::service::common::types::{
    array_types::impl_array_types, generic, string_types::impl_string_types,
};

/// Title.
const TITLE: &str = "Signed Document Version";
/// Description.
const DESCRIPTION: &str = "Unique [Document Version](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver).  

UUIDv7 Formatted 128bit value.";
/// Example.
const EXAMPLE: &str = "01944e87-e68c-7f22-9df1-816863cfa5ff";
/// Example - Range min.
const EXAMPLE_MAX: &str = "01944e87-e68c-7f22-9df1-000000000000";
/// Example - Ranged max
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

impl DocumentVer {
    /// Creates a new `DocumentVer` instance without validation.
    /// **NOTE** could produce an invalid instance, be sure that passing `String` is a
    /// valid `DocumentVer`
    pub(crate) fn new_unchecked(uuid: String) -> Self {
        Self(uuid)
    }
}

impl Example for DocumentVer {
    /// An example.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl DocumentVer {
    /// An example of a minimum Document ID when specifying ranges
    pub(crate) fn example_min() -> Self {
        Self(EXAMPLE_MIN.to_owned())
    }

    /// An example of a maximum Document ID when specifying ranges
    pub(crate) fn example_max() -> Self {
        Self(EXAMPLE_MAX.to_owned())
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
            bail!("Invalid DocumentVer '{value}', must be a valid UUIDv7")
        }
        Ok(Self(value))
    }
}

impl From<uuidv7::UUIDv7> for DocumentVer {
    fn from(value: uuidv7::UUIDv7) -> Self {
        Self(value.to_string())
    }
}

impl From<catalyst_signed_doc::UuidV7> for DocumentVer {
    fn from(value: catalyst_signed_doc::UuidV7) -> Self {
        Self(value.to_string())
    }
}

// List of Document Versions
impl_array_types!(
    DocumentVers,
    DocumentVer,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(1000),
        items: Some(Box::new(DocumentVer::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for DocumentVers {
    fn example() -> Self {
        Self(vec![DocumentVer::example()])
    }
}

impl PartialEq for DocumentVers {
    fn eq(&self, other: &Self) -> bool {
        self.0.eq(&other.0)
    }
}
