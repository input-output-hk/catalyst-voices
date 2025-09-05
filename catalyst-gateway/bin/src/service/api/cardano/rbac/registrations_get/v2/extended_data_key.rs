//! An extended data key.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// A schema.
#[allow(clippy::cast_precision_loss)]
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some("Extended data key".into()),
        description: Some("An extended data key"),
        example: ExtendedDataKey::example().to_json(),
        minimum: Some(0.),
        maximum: Some(255.),
        ..MetaSchema::ANY
    }
});

/// An extended data key.
#[derive(Debug, Clone)]
pub struct ExtendedDataKey(pub u8);

impl From<u8> for ExtendedDataKey {
    fn from(val: u8) -> Self {
        Self(val)
    }
}

impl Type for ExtendedDataKey {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "ExtendedDataKey".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("integer", "u8")));
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

impl Example for ExtendedDataKey {
    fn example() -> Self {
        Self(1)
    }
}

impl ToJSON for ExtendedDataKey {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl ParseFromParameter for ExtendedDataKey {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        Ok(Self(value.parse()?))
    }
}

impl ParseFromJSON for ExtendedDataKey {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        u64::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(TryInto::try_into)?
            .map_err(ParseError::custom)
            .map(Self)
    }
}
