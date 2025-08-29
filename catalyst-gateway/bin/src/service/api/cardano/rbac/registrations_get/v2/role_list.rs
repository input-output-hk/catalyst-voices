//! A list of RBAC role data.

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::{
    api::cardano::rbac::registrations_get::v2::role_data::RbacRoleData,
    common::types::array_types::impl_array_types,
};

impl_array_types!(
    /// A list of RBAC role data.
    RbacRoleList,
    RbacRoleData,
    Some(MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(RbacRoleData::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for RbacRoleList {
    fn example() -> Self {
        Self(vec![RbacRoleData::example()])
    }
}
