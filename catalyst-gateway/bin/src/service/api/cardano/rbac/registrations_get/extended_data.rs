//! A role extended data.

use std::{collections::HashMap, sync::LazyLock};

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};

/// A title.
const TITLE: &str = "Role extended data";
/// A description.
const DESCRIPTION: &str = "An arbitrary extended data for the role";

/// A schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: ExtendedData::example().to_json(),
        ..MetaSchema::ANY
    }
});

/// A role extended data.
#[derive(Debug, Eq, PartialEq, Clone)]
pub(crate) struct ExtendedData(HashMap<u8, Vec<u8>>);

impl From<HashMap<u8, Vec<u8>>> for ExtendedData {
    fn from(value: HashMap<u8, Vec<u8>>) -> Self {
        Self(value)
    }
}

impl Type for ExtendedData {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "ExtendedData".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("object", "map")));
        schema_ref.merge(SCHEMA.clone())
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(self)
    }

    fn raw_element_iter<'a>(
        &'a self,
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }

    fn is_empty(&self) -> bool {
        self.0.is_empty()
    }
}

impl ToJSON for ExtendedData {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(serde_json::Value::Object(
            self.0
                .iter()
                .map(|(key, val)| (key.to_string(), val.clone().into()))
                .collect(),
        ))
    }
}

impl ParseFromJSON for ExtendedData {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        HashMap::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(Self)
    }
}

impl Example for ExtendedData {
    fn example() -> Self {
        Self([(10, vec![1, 2, 3])].into_iter().collect())
    }
}
