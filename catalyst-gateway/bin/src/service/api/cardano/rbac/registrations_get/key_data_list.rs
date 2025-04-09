//! A list of `KeyData`.

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::{
    api::cardano::rbac::registrations_get::key_data::KeyData,
    common::types::array_types::impl_array_types,
};

impl_array_types!(
    /// A list of `KeyData`.
    KeyDataList,
    KeyData,
    Some(MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(KeyData::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for KeyDataList {
    fn example() -> Self {
        Self(vec![KeyData::example()])
    }
}
