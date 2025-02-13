//! Implement newtype of `ErrorList`

use derive_more::{From, Into};
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};

use super::error_msg::ErrorMessage;

#[derive(Debug, Clone, Default, From, Into)]
pub(crate) struct ErrorList(Vec<ErrorMessage>);

impl Type for ErrorList {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "SemanticVersion".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new("array"))).merge(MetaSchema {
            example: Self::example().to_json(),
            max_items: Some(10),
            ..poem_openapi::registry::MetaSchema::ANY
        })
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

impl ParseFromJSON for ErrorList {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        Ok(Self(
            Vec::parse_from_json(value).map_err(|e| ParseError::custom(e.into_message()))?,
        ))
    }
}

impl ToJSON for ErrorList {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(serde_json::Value::Array(
            self.0
                .iter()
                .map(ToJSON::to_json)
                .filter_map(|v| v)
                .collect(),
        ))
    }
}

impl Example for ErrorList {
    fn example() -> Self {
        Self(vec!["Stake Public Key is required".into()])
    }
}
