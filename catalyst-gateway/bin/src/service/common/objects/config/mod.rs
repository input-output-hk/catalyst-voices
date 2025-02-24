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
    #[oai(default, skip_serializing_if_is_empty)]
    schema_validation_errors: common::types::generic::error_list::ErrorList,
}

impl ConfigUnprocessableContent {
    /// Create a new instance of `ConfigBadRequest`.
    pub(crate) fn new(
        error: String,
        schema_validation_errors: Option<common::types::generic::error_list::ErrorList>,
    ) -> Self {
        Self {
            error: error.into(),
            schema_validation_errors: schema_validation_errors.unwrap_or_default(),
        }
    }
}

impl Example for ConfigUnprocessableContent {
    fn example() -> Self {
        Self {
            error: "Invalid Data".to_string().into(),
            schema_validation_errors: Example::example(),
        }
    }
}
