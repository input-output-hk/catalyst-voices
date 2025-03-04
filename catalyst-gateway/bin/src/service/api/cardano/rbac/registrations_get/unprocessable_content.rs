//! Bad Rbac registration endpoint arguments.

use poem_openapi::{types::Example, Object};

use crate::service::common;

/// Rbac Registration Validation Error.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacUnprocessableContent {
    /// Error message.
    error: common::types::generic::error_msg::ErrorMessage,
}

impl RbacUnprocessableContent {
    /// Create a new instance of `ConfigBadRequest`.
    pub(crate) fn new(error: &(impl ToString + ?Sized)) -> Self {
        Self {
            error: error.to_string().into(),
        }
    }
}

impl Example for RbacUnprocessableContent {
    fn example() -> Self {
        Self::new("Missing Document in request body")
    }
}
