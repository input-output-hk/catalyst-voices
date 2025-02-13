//! Implement newtype of `ErrorList`

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};

use super::error_msg::ErrorMessage;
use crate::service::common::types::array_types::impl_array_types;

// List of Errors
impl_array_types!(
    ErrorList,
    ErrorMessage,
    Some(MetaSchema {
        example: ErrorList::example().to_json(),
        max_items: Some(10),
        items: Some(Box::new(ErrorMessage::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for ErrorList {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}
