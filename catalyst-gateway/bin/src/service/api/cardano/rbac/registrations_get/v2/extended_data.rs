//! A role extended data.

use poem_openapi::types::Example;
use poem_openapi_derive::Object;

use crate::service::api::cardano::rbac::registrations_get::v2::{
    extended_data_key::ExtendedDataKey, extended_data_value::ExtendedDataValue,
};

/// A role extended data.
#[derive(Object, Debug, Clone)]
pub struct ExtendedData {
    /// A key of the data.
    key: ExtendedDataKey,
    /// A value of the data.
    value: ExtendedDataValue,
}

impl ExtendedData {
    /// Creates a new instance of extended data.
    pub fn new(
        key: u8,
        value: Vec<u8>,
    ) -> Self {
        Self {
            key: key.into(),
            value: value.into(),
        }
    }
}

impl Example for ExtendedData {
    fn example() -> Self {
        Self {
            key: ExtendedDataKey::example(),
            value: ExtendedDataValue::example(),
        }
    }
}
