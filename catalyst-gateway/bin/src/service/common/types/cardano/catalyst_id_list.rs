//! Implement newtype of `RegistrationList`

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::common::types::{
    array_types::impl_array_types, cardano::catalyst_id::CatalystId,
};

impl_array_types!(
    CatalystIdList,
    CatalystId,
    Some(MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(CatalystId::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for CatalystIdList {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}
