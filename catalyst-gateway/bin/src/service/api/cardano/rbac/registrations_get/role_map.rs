//! A RBAC role data map.

use std::{collections::HashMap, sync::LazyLock};

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};

use crate::service::api::cardano::rbac::registrations_get::role_data::RbacRoleData;

/// A title.
const TITLE: &str = "RBAC role data map";
/// A description.
const DESCRIPTION: &str = "A RBAC role data map.";

/// A schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: RoleMap::example().to_json(),
        ..MetaSchema::ANY
    }
});

/// A RBAC role data map.
#[derive(Debug, Clone)]
pub(crate) struct RoleMap(HashMap<u8, RbacRoleData>);

impl From<HashMap<u8, RbacRoleData>> for RoleMap {
    fn from(value: HashMap<u8, RbacRoleData>) -> Self {
        Self(value)
    }
}

impl Type for RoleMap {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "RoleMap".into()
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

impl ToJSON for RoleMap {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(serde_json::Value::Object(
            self.0
                .iter()
                .filter_map(|(key, val)| val.to_json().map(|v| (key.to_string(), v)))
                .collect(),
        ))
    }
}

impl ParseFromJSON for RoleMap {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        HashMap::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(Self)
    }
}

impl Example for RoleMap {
    fn example() -> Self {
        Self([(0, RbacRoleData::example())].into_iter().collect())
    }
}
