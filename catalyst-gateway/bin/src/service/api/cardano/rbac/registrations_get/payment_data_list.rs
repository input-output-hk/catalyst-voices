//! A list of `PaymentData`.

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::{
    api::cardano::rbac::registrations_get::payment_data::PaymentData,
    common::types::array_types::impl_array_types,
};

impl_array_types!(
    /// A list of `PaymentData`.
    PaymentDataList,
    PaymentData,
    Some(MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(PaymentData::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for PaymentDataList {
    fn example() -> Self {
        Self(vec![PaymentData::example()])
    }
}
