//! Signed Document Type
//!
//! List of `UUIDv4`.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};
use uuid::Uuid;

use self::generic::uuidv4;
use crate::service::common::types::generic::{self, uuidv4::UUIDv4};

/// Document type - list of `UUIDv4`
#[derive(Debug, Clone)]
pub(crate) struct DocumentType(Vec<uuidv4::UUIDv4>);

/// Title.
const TITLE: &str = "Signed Document Type";
/// Description.
const DESCRIPTION: &str = "Document Type. List UUIDv4 Formatted 128bit value.";
/// External Documentation URI
const URI: &str =
    "https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/";
/// Description of the URI
const URI_DESCRIPTION: &str = "Specification";
/// Maximum length
const MAX_LENGTH: usize = usize::MAX;
/// Minimum length
const MIN_LENGTH: usize = 1;
/// Schema
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.into()),
        description: Some(DESCRIPTION),
        max_length: Some(MAX_LENGTH),
        min_length: Some(MIN_LENGTH),
        external_docs: Some(MetaExternalDocument {
            url: URI.to_owned(),
            description: Some(URI_DESCRIPTION.to_owned()),
        }),
        ..MetaSchema::ANY
    }
});

impl DocumentType {
    /// Convert to sql format used for filter '{"uuid", "uuid"}'
    pub(crate) fn to_sql_array(&self) -> String {
        format!(
            "{{{}}}",
            self.0
                .iter()
                .map(|uuid| uuid.to_string())
                .collect::<Vec<String>>()
                .join(",")
        )
    }
}

impl Type for DocumentType {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "DocumentType".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("array", "string")));
        schema_ref.merge(SCHEMA.clone())
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(self)
    }

    fn raw_element_iter<'a>(
        &'a self,
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }
}

impl ParseFromJSON for DocumentType {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        Vec::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(Self)
    }
}

impl Example for DocumentType {
    fn example() -> Self {
        Self(vec![uuidv4::UUIDv4::example(), uuidv4::UUIDv4::example()])
    }
}

impl ToJSON for DocumentType {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(serde_json::Value::Array(
            self.0
                .iter()
                .filter_map(poem_openapi::types::ToJSON::to_json)
                .collect(),
        ))
    }
}

impl From<Vec<Uuid>> for DocumentType {
    fn from(value: Vec<uuid::Uuid>) -> Self {
        Self(value.into_iter().map(uuidv4::UUIDv4::from).collect())
    }
}

impl From<Vec<String>> for DocumentType {
    fn from(value: Vec<String>) -> Self {
        Self(
            value
                .into_iter()
                .filter_map(|s| Uuid::parse_str(&s).ok().map(UUIDv4::from))
                .collect(),
        )
    }
}
