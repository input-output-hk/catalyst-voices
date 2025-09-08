//! A hex encoded extended data value.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::{common::types::string_types::impl_string_types, utilities::as_hex_string};

/// A schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some("Extended data value".into()),
        description: Some("A hex encoded extended data value."),
        example: ExtendedDataValue::example().to_json(),
        pattern: Some("^0x[A-Fa-f0-9]+$".into()),
        ..MetaSchema::ANY
    }
});

impl_string_types!(
    /// A hex encoded extended data value.
    ExtendedDataValue,
    "string",
    "hex",
    Some(SCHEMA.clone())
);

impl Example for ExtendedDataValue {
    fn example() -> Self {
        vec![1, 2, 3].into()
    }
}

impl From<Vec<u8>> for ExtendedDataValue {
    fn from(val: Vec<u8>) -> Self {
        Self(as_hex_string(&val))
    }
}
