//! Define `ValidationError` type.

use poem_openapi::Object;

/// Common error message type.
/// It has failed to pass validation, as specified by the `OpenAPI` schema.
#[derive(Object)]
pub(crate) struct ValidationError {
    /// Error message
    #[oai(validator(max_length = "1000"))]
    message: String,
}

impl ValidationError {
    /// Create a new `ValidationError`
    pub(crate) fn new(message: String) -> Self {
        Self { message }
    }
}
