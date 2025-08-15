//! A Catalyst user role identifier wrapper.

use std::{
    fmt::{self, Display},
    sync::LazyLock,
};

use catalyst_types::catalyst_id::role_index::RoleId;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};

/// A schema.
#[allow(clippy::cast_precision_loss)]
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(CatalystRoleId::name().into()),
        description: Some("Catalyst user role identifier"),
        example: Some(
            // This operation is infallible.
            #[allow(clippy::expect_used)]
            CatalystRoleId::example()
                .to_json()
                .expect("Unable to convert CatalystRoleId example to JSON"),
        ),
        maximum: Some(0.),
        minimum: Some(0.),
        ..MetaSchema::ANY
    }
});

/// A Catalyst user role identifier.
#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy, PartialOrd, Ord)]
pub(crate) struct CatalystRoleId(u8);

impl From<RoleId> for CatalystRoleId {
    fn from(value: RoleId) -> Self {
        Self(value.into())
    }
}

impl Display for CatalystRoleId {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl Example for CatalystRoleId {
    fn example() -> Self {
        RoleId::Role0.into()
    }
}

impl Type for CatalystRoleId {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "CatalystRoleId".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("integer", "u8")));
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
}

impl ParseFromJSON for CatalystRoleId {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        u8::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(Self)
    }
}

impl ParseFromParameter for CatalystRoleId {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        Ok(Self(value.parse()?))
    }
}

impl ToJSON for CatalystRoleId {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(self.0.into())
    }
}
