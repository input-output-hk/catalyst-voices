//! Implement newtype of `RegistrationList`

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::{
    api::cardano::cip36::response::Cip36Details, common::types::array_types::impl_array_types,
};

// List of CIP-36 Registrations
impl_array_types!(
    RegistrationCip36List,
    Cip36Details,
    Some(MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(Cip36Details::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for RegistrationCip36List {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}
