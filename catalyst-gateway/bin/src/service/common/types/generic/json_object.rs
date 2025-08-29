//! `JsonObject` Type.

use std::ops::{Deref, DerefMut};

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};
use serde_json::{json, Map, Value};

/// `JSON` Object API definition
#[derive(Debug, Clone, Eq, PartialEq, Hash)]
pub(crate) struct JsonObject(Map<String, Value>);

impl Deref for JsonObject {
    type Target = Map<String, Value>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl DerefMut for JsonObject {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

impl Type for JsonObject {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "JsonObject".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema {
            ty: "object",
            example: Some(json!({"name": "Alex"})),
            ..poem_openapi::registry::MetaSchema::ANY
        }))
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

impl ParseFromJSON for JsonObject {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        if let Value::Object(obj) = value {
            Ok(Self(obj))
        } else {
            Err(ParseError::expected_type(value))
        }
    }
}

impl ToJSON for JsonObject {
    fn to_json(&self) -> Option<Value> {
        Some(Value::Object(self.0.clone()))
    }
}

impl Example for JsonObject {
    /// An example `UUIDv4`
    fn example() -> Self {
        let mut obj = Map::new();
        obj.insert("name".to_string(), Value::String("Alex".to_string()));
        Self(obj)
    }
}

impl TryFrom<Value> for JsonObject {
    type Error = anyhow::Error;

    fn try_from(value: Value) -> Result<Self, Self::Error> {
        if let Value::Object(obj) = value {
            Ok(Self(obj))
        } else {
            anyhow::bail!("Provided JSON value not an object {value}")
        }
    }
}

impl From<JsonObject> for Value {
    fn from(value: JsonObject) -> Self {
        Value::Object(value.0)
    }
}

impl From<JsonObject> for Map<String, Value> {
    fn from(value: JsonObject) -> Self {
        value.0
    }
}
