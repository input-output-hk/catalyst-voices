//! An extended data key.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// A schema.
#[allow(clippy::cast_precision_loss)]
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some("Extended data key".into()),
        description: Some("An extended data key"),
        example: ExtendedDataValue::example().to_json(),
        max_items: Some(32_768),
        items: Some(Box::new(MetaSchemaRef::Reference("integer".into()))),
        ..MetaSchema::ANY
    }
});

/// An extended data key.
#[derive(Debug, Clone)]
pub struct ExtendedDataValue(pub Vec<u8>);

impl From<Vec<u8>> for ExtendedDataValue {
    fn from(val: Vec<u8>) -> Self {
        Self(val)
    }
}

impl Type for ExtendedDataValue {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "ExtendedDataValue".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref = MetaSchemaRef::Inline(Box::new(MetaSchema::new("array")));
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

impl Example for ExtendedDataValue {
    fn example() -> Self {
        Self(vec![1, 2, 3])
    }
}

impl ToJSON for ExtendedDataValue {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.clone().into())
    }
}

impl ParseFromJSON for ExtendedDataValue {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        <Vec<u8>>::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(TryInto::try_into)?
            .map_err(ParseError::custom)
            .map(Self)
    }
}
