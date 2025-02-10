//! Implement API endpoint interfacing `DateTime`.

use derive_more::{From, FromStr, Into};
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseFromParameter, ParseResult, Type},
};

/// Newtype for `DateTime<Utc>`. Should be used for API interfacing `DateTime<Utc>` only.
#[derive(Debug, Clone, From, FromStr, Into)]
pub(crate) struct ApiDateTime(chrono::DateTime<chrono::offset::Utc>);

impl Type for ApiDateTime {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "date_time".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("string", "date-time"))).merge(
            MetaSchema {
                title: Some("RFC 3339 Date and Time".into()),
                description: Some("RFC 3339 date and time."),
                example: Some(Self::example().0.to_rfc3339().into()),
                ..poem_openapi::registry::MetaSchema::ANY
            },
        )
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

impl ParseFromParameter for ApiDateTime {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        Ok(Self(value.parse()?))
    }
}

impl Example for ApiDateTime {
    fn example() -> Self {
        Self(chrono::Utc::now())
    }
}
