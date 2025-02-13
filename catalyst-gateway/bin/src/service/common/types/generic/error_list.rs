//! Implement newtype of `ErrorList`

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};

use super::error_msg::ErrorMessage;
use crate::service::common::types::array_types::impl_array_types;

/// `OpenAPI` schema for the header in documentation.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        example: ErrorList::example().to_json(),
        max_items: Some(10),
        items: Some(Box::new(ErrorMessage::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

// List of Errors
impl_array_types!(ErrorList, ErrorMessage, Some(SCHEMA.clone()));

impl Example for ErrorList {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}
