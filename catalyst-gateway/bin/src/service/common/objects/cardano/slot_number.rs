//! Implement slot number.

use derive_more::{From, FromStr, Into};
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef, Registry},
    types::{Example, ParseFromParameter, ParseResult, Type},
};

/// Newtype for slot number.
#[derive(Debug, Clone, From, FromStr, Into)]
pub(crate) struct SlotNumber(i64);

impl SlotNumber {
    /// Creates a `SlotNumber` schema definition.
    fn schema() -> MetaSchema {
        MetaSchema::new("string").merge(MetaSchema {
            title: Some("Slot Number".into()),
            description: Some("Cardano slot number."),
            example: Some(Self::example().0.into()),
            minimum: Some(0.0),
            maximum: Some(9_223_372_036_854_775_807.0),
            ..poem_openapi::registry::MetaSchema::ANY
        })
    }
}

impl Type for SlotNumber {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "SlotNumber".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Reference(Self::name().to_string())
    }

    fn register(registry: &mut Registry) {
        registry.create_schema::<Self, _>(Self::name().to_string(), |_| Self::schema());
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

impl ParseFromParameter for SlotNumber {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        Ok(Self(value.parse()?))
    }
}

impl Example for SlotNumber {
    fn example() -> Self {
        Self(432_000)
    }
}
