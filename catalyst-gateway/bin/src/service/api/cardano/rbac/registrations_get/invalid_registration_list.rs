//! A list of invalid RBAC registrations.

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::{
    api::cardano::rbac::registrations_get::invalid_registration::InvalidRegistration,
    common::types::array_types::impl_array_types,
};

impl_array_types!(
    /// A list of invalid RBAC registrations.
    InvalidRegistrationList,
    InvalidRegistration,
    Some(MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(InvalidRegistration::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for InvalidRegistrationList {
    fn example() -> Self {
        Self(vec![InvalidRegistration::example()])
    }
}
