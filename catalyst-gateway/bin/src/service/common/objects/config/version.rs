//! Implement newtype for `Version`

use core::fmt;

use derive_more::{From, Into};
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};

/// Semantic Versioning String
#[derive(Debug, Clone, From, Into)]
pub(crate) struct SemVer(String);

impl Type for SemVer {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "SemanticVersion".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(
            MetaSchema::new("string")
        )).merge(
            MetaSchema {
                description: Some("Semantic Versioning string following semver.org 2.0.0 specification."),
                example: Some(Self::example().0.into()),
                max_length: Some(64),
                pattern: Some("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9A-Za-z-][0-9A-Za-z-]*)(?:\\.(?:0|[1-9A-Za-z-][0-9A-Za-z-]*))*))?(?:\\+([0-9A-Za-z-]+(?:\\.[0-9A-Za-z-]+)*))?$".into()),
                ..poem_openapi::registry::MetaSchema::ANY
            }
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

impl ParseFromJSON for SemVer {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        Ok(Self(
            String::parse_from_json(value).map_err(|e| ParseError::custom(e.into_message()))?,
        ))
    }
}

impl ToJSON for SemVer {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(self.to_string().into())
    }
}

impl fmt::Display for SemVer {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.0)?;
        Ok(())
    }
}

impl Example for SemVer {
    fn example() -> Self {
        Self("1.0.0".into())
    }
}
