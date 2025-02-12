//! Implement API endpoint interfacing `DateTime`.

use core::fmt;

use derive_more::{From, FromStr, Into};
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};

/// Newtype for `DateTime<Utc>`. Should be used for API interfacing `DateTime<Utc>` only.
#[derive(Debug, Clone, From, FromStr, Into)]
pub(crate) struct DateTime(chrono::DateTime<chrono::offset::Utc>);

impl DateTime {
    /// Returns a `DateTime<Utc>` which corresponds to the current date and time in UTC.
    pub(crate) fn now() -> Self {
        Self(chrono::Utc::now())
    }
}

impl Type for DateTime {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "ApiDateTime".into()
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

impl ParseFromParameter for DateTime {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        Ok(Self(value.parse()?))
    }
}

impl ParseFromJSON for DateTime {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        let value = value.ok_or(ParseError::custom(
            "Invalid RFC 3339 date and time. Null or missing value.",
        ))?;
        let value = value.as_str().ok_or(ParseError::custom(
            "Invalid RFC 3339 date and time. Must be string.",
        ))?;
        Ok(Self(value.parse()?))
    }
}

impl ToJSON for DateTime {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(self.to_string().into())
    }
}

impl fmt::Display for DateTime {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.0.to_rfc3339())?;
        Ok(())
    }
}

impl Example for DateTime {
    fn example() -> Self {
        Self(chrono::DateTime::from_timestamp(1_712_676_501, 0).unwrap_or_default())
    }
}
