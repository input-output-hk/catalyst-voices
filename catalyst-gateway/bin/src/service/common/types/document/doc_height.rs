//! A consecutive sequence number of the current document in the chain.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// A title.
const TITLE: &str = "A document height";
/// A description.
const DESCRIPTION: &str = "A consecutive sequence number of the current document in the chain.";

/// Schema.
#[allow(clippy::cast_precision_loss)]
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: DocumentHeight::example().to_json(),
        maximum: Some(i32::MAX as f64),
        minimum: Some(i32::MIN as f64),
        ..MetaSchema::ANY
    }
});

/// A consecutive sequence number of the current document in the chain.
#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy, PartialOrd, Ord)]
pub(crate) struct DocumentHeight(i32);

impl Default for DocumentHeight {
    fn default() -> Self {
        Self(0)
    }
}

impl Type for DocumentHeight {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "DocumentHeight".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("integer", "i32")));
        schema_ref.merge(SCHEMA.clone())
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(self)
    }

    fn raw_element_iter<'a>(
        &'a self
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }
}

impl From<i32> for DocumentHeight {
    fn from(val: i32) -> Self {
        Self(val)
    }
}

impl Example for DocumentHeight {
    fn example() -> Self {
        Self(0)
    }
}

impl ParseFromJSON for DocumentHeight {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        i32::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(Into::into)
    }
}

impl ToJSON for DocumentHeight {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}
