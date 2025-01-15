//! Bad Document PUT request.

use poem_openapi::{types::Example, Object};

/// Configuration Data Validation Error.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct PutDocumentBadRequest {
    /// Error messages.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    error: String,
    // TODO: Add optional verbose error fields for documents that fail validation.
}

impl PutDocumentBadRequest {
    /// Create a new instance of `ConfigBadRequest`.
    pub(crate) fn new(error: &str) -> Self {
        Self {
            error: error.to_owned(),
        }
    }
}

impl Example for PutDocumentBadRequest {
    fn example() -> Self {
        PutDocumentBadRequest::new("Missing Document in request body")
    }
}
