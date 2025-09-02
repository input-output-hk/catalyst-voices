//! A list of `ExtendedData`.

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::{
    api::cardano::rbac::registrations_get::v2::{extended_data::ExtendedData, key_data::KeyData},
    common::types::array_types::impl_array_types,
};

impl_array_types!(
    /// A list of `ExtendedData`.
    ExtendedDataList,
    ExtendedData,
    Some(MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(KeyData::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for ExtendedDataList {
    fn example() -> Self {
        Self(vec![ExtendedData::example()])
    }
}
