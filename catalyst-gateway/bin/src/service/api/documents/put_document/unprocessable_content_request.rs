//! Bad Document PUT request.

use poem_openapi::{types::Example, Object};

/// Put Document Validation Error.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct PutDocumentUnprocessableContent {
    /// Error messages.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    error: String,
    /// Error report JSON object.
    #[oai(skip_serializing_if_is_none)]
    report: Option<serde_json::Value>,
}

impl PutDocumentUnprocessableContent {
    /// Create a new instance of `ConfigBadRequest`.
    pub(crate) fn new(error: &(impl ToString + ?Sized), report: Option<serde_json::Value>) -> Self {
        Self {
            error: error.to_string(),
            report,
        }
    }
}

impl Example for PutDocumentUnprocessableContent {
    fn example() -> Self {
        PutDocumentUnprocessableContent::new("Missing Document in request body", None)
    }
}
