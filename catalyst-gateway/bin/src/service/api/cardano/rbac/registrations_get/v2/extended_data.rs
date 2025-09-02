//! A role extended data.

use poem_openapi::types::Example;
use poem_openapi_derive::Object;

/// A role extended data.
#[derive(Object, Debug, Eq, PartialEq, Clone)]
pub struct ExtendedData {
    /// A key of the data.
    key: u8,
    /// A value of the data.
    value: Vec<u8>,
}

impl ExtendedData {
    pub fn new(
        key: u8,
        value: Vec<u8>,
    ) -> Self {
        Self { key, value }
    }
}

impl Example for ExtendedData {
    fn example() -> Self {
        Self {
            key: 1,
            value: vec![1, 2, 3],
        }
    }
}
