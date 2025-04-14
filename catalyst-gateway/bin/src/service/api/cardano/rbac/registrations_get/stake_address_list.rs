//! A list of stake addresses.

use poem_openapi::{
    registry::MetaSchema,
    types::{Example, ToJSON},
};

use crate::service::common::types::{
    array_types::impl_array_types, cardano::cip19_stake_address::Cip19StakeAddress,
};

impl_array_types!(
    /// A list of stake addresses.
    Cip19StakeAddressList,
    Cip19StakeAddress,
    Some(MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(Cip19StakeAddress::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for Cip19StakeAddressList {
    fn example() -> Self {
        Self(vec![Cip19StakeAddress::example()])
    }
}
