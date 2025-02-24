//! Implement `JSONObject`.

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};

/// Represents any JSON object used to interfacing as an API object.
#[derive(Debug, Clone)]
pub(crate) struct JSONObject(serde_json::Value);

impl Type for JSONObject {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "JSONObject".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new("object"))).merge(MetaSchema {
            description: Some("A JSON object for holding any custom information inside it."),
            example: Some(Self::example().0),
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

impl ParseFromJSON for JSONObject {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        serde_json::Value::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(Self)
    }
}

impl ToJSON for JSONObject {
    fn to_json(&self) -> Option<serde_json::Value> {
        self.0.to_json()
    }
}

impl Example for JSONObject {
    fn example() -> Self {
        Self(serde_json::json!({}))
    }
}
