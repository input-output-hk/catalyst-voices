//! A map of binary encoded certificates.

use std::{borrow::Cow, collections::HashMap};

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef, Registry},
    types::{Example, ParseFromJSON, ToJSON, Type},
};

/// An inner type for the map.
type Inner = HashMap<usize, Vec<Option<Vec<u8>>>>;

/// A map of binary encoded certificates.
#[derive(Debug, Default, Clone)]
pub(crate) struct CertificateMap(Inner);

impl From<Inner> for CertificateMap {
    fn from(value: Inner) -> Self {
        Self(value)
    }
}

impl Type for CertificateMap {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> Cow<'static, str> {
        "CertificateMap".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref = MetaSchemaRef::Inline(Box::new(MetaSchema::new("object")));
        schema_ref.merge(MetaSchema {
            example: Self::example().to_json(),
            min_items: Some(1),
            max_items: Some(10000),
            ..MetaSchema::ANY
        })
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(self)
    }

    fn register(registry: &mut Registry) {
        // note: to prevent `item_ty` from not being attached to the schema.
        Inner::register(registry);
    }

    fn raw_element_iter<'a>(
        &'a self,
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }

    #[inline]
    fn is_empty(&self) -> bool {
        self.0.is_empty()
    }
}

impl ParseFromJSON for CertificateMap {
    fn parse_from_json(value: Option<serde_json::Value>) -> poem_openapi::types::ParseResult<Self> {
        HashMap::parse_from_json(value)
            .map_err(poem_openapi::types::ParseError::propagate)
            .map(Self)
    }
}

impl ToJSON for CertificateMap {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(serde_json::Value::Object(
            self.0
                .iter()
                .filter_map(|(k, v)| ToJSON::to_json(v).map(|v| (k.to_string(), v)))
                .collect(),
        ))
    }
}

impl Example for CertificateMap {
    fn example() -> Self {
        Self(HashMap::new())
    }
}
