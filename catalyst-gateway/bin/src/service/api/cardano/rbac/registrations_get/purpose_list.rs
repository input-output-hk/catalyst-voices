//! A list of RBAC registration purposes.

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::common::types::{array_types::impl_array_types, generic::uuidv4::UUIDv4};

impl_array_types!(
    /// A list of RBAC registration purposes.
    PurposeList,
    UUIDv4,
    Some(MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(UUIDv4::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for PurposeList {
    fn example() -> Self {
        Self(vec![UUIDv4::example()])
    }
}
