//! A map of role number to role data.

use std::{borrow::Cow, collections::HashMap};

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef, Registry},
    types::{Example, ParseFromJSON, ToJSON, Type},
};

// TODO: FIXME: Different  value.
/// An inner type for the map.
type Inner = HashMap<u8, Vec<Option<Vec<u8>>>>;

// TODO: FIXME:
// {
//     role_0: RoleData,
//     role_x: RoleData,
//     ...
// }
//
// RoleData {
//     signing_keys: [KeyData],
//     encryption_keys: [KeyData],
//     payment_address: [time, cip19_address],
//     extended_data: Map<u8, Vec<u8>>,
// }
//
// KeyData {
//     time,
//     key: Option<key>,
//     c509: Option<cert>,
//     x509: Option<cert>,
// }

/// A map of role number to role data.
#[derive(Debug, Default, Clone)]
pub(crate) struct RoleMap(Inner);

impl RoleMap {
    pub(crate) fn new() -> Self {
        todo!()
        // TODO: FIXME:
        // Self()
    }
}

impl Type for RoleMap {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> Cow<'static, str> {
        "RoleMap".into()
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

impl ParseFromJSON for RoleMap {
    fn parse_from_json(value: Option<serde_json::Value>) -> poem_openapi::types::ParseResult<Self> {
        // TODO: FIXME:
        todo!()
        // HashMap::parse_from_json(value)
        //     .map_err(poem_openapi::types::ParseError::propagate)
        //     .map(Self)
    }
}

impl ToJSON for RoleMap {
    fn to_json(&self) -> Option<serde_json::Value> {
        // TODO: FIXME:
        todo!()
        // Some(serde_json::Value::Object(
        //     self.0
        //         .iter()
        //         .filter_map(|(k, v)| ToJSON::to_json(v).map(|v| (k.to_string(), v)))
        //         .collect(),
        // ))
    }
}

impl Example for RoleMap {
    fn example() -> Self {
        Self(HashMap::new())
    }
}
