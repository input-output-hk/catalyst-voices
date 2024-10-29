//! Config object definitions.

pub(crate) mod frontend_config;

use poem_openapi::{types::Example, Object};

/// Configuration Data Validation Error.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct ConfigBadRequest {
    /// Error messages.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    error: String,
    /// Optional schema validation errors.
    #[oai(validator(max_items = "1000", max_length = "9999", pattern = "^[0-9a-zA-Z].*$"))]
    schema_validation_errors: Option<Vec<String>>,
}

impl ConfigBadRequest {
    /// Create a new instance of `ConfigBadRequest`.
    pub(crate) fn new(error: String, schema_validation_errors: Option<Vec<String>>) -> Self {
        Self {
            error,
            schema_validation_errors,
        }
    }
}

impl Example for ConfigBadRequest {
    fn example() -> Self {
        ConfigBadRequest {
            error: "Invalid Data".to_string(),
            schema_validation_errors: Some(vec!["Error message".to_string()]),
        }
    }
}
