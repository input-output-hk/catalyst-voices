//! Define `ValidationError` type.

use poem_openapi::Object;

/// Common error message type.
/// It has failed to pass validation, as specified by the `OpenAPI` schema.
#[derive(Object)]
pub(crate) struct ValidationError {
    /// Error message
    #[oai(validator(max_length = "100"))]
    pub(crate) message: String,
}
