//! Config object definitions.

mod environment;
pub(crate) mod frontend_config;
mod version;

use poem_openapi::{types::Example, Object};

use crate::service::common;

/// Configuration Data Validation Error.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct ConfigUnprocessableContent {
    /// Error messages.
    error: common::types::generic::error_msg::ErrorMessage,
    /// Optional schema validation errors.
    #[oai(validator(max_items = "1000", max_length = "9999", pattern = "^[0-9a-zA-Z].*$"))]
    schema_validation_errors: Option<Vec<String>>,
}

impl ConfigUnprocessableContent {
    /// Create a new instance of `ConfigBadRequest`.
    pub(crate) fn new(error: String, schema_validation_errors: Option<Vec<String>>) -> Self {
        Self {
            error: error.into(),
            schema_validation_errors,
        }
    }
}

impl Example for ConfigUnprocessableContent {
    fn example() -> Self {
        Self {
            error: "Invalid Data".to_string().into(),
            schema_validation_errors: Some(vec!["Error message".to_string()]),
        }
    }
}
