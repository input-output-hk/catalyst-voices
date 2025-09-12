//! Bad Document PUT request.

use poem_openapi::{types::Example, Object};

use crate::service::common;

/// Put Document Validation Error.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct PutDocumentUnprocessableContent {
    /// Error messages.
    error: common::types::generic::error_msg::ErrorMessage,
    /// Error report JSON object.
    #[oai(skip_serializing_if_is_none)]
    report: Option<common::objects::generic::problem_report::ProblemReport>,
}

impl PutDocumentUnprocessableContent {
    /// Create a new instance of `ConfigBadRequest`.
    pub(crate) fn new(
        error: &(impl ToString + ?Sized),
        _report: Option<catalyst_signed_doc::ProblemReport>,
    ) -> Self {
        Self {
            error: error.to_string().into(),
            // TODO: (apskhem) put error back when catalyst-signed-doc is ready
            report: None,
        }
    }
}

impl Example for PutDocumentUnprocessableContent {
    fn example() -> Self {
        Self::new(
            "Missing Document in request body",
            Some(catalyst_signed_doc::ProblemReport::new(
                "Missing Document in request body",
            )),
        )
    }
}
