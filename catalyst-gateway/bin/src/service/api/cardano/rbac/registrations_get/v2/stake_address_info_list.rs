//! A list of `StakeAddressInfo`.

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::{
    api::cardano::rbac::registrations_get::v2::stake_address_info::RbacStakeAddressInfo,
    common::types::array_types::impl_array_types,
};

impl_array_types!(
    /// A list of `StakeAddressInfo`.
    StakeAddressInfoList,
    RbacStakeAddressInfo,
    Some(MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(RbacStakeAddressInfo::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for StakeAddressInfoList {
    fn example() -> Self {
        Self(vec![RbacStakeAddressInfo::example()])
    }
}
