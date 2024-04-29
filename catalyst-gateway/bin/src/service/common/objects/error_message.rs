//! Define `ErrorMessage` type.

use poem_openapi::Object;

/// Common error message type.
#[derive(Object)]
pub(crate) struct ErrorMessage {
    /// Error message
    #[oai(validator(max_length = "100"))]
    pub(crate) message: String,
}
