//! Bad Document PUT request.

use catalyst_types::problem_report::ProblemReport;
use poem_openapi::{Object, types::Example};

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
        report: Option<&ProblemReport>,
    ) -> Self {
        Self {
            error: error.to_string().into(),
            report: report.map(Into::into),
        }
    }
}

impl Example for PutDocumentUnprocessableContent {
    fn example() -> Self {
        Self::new(
            "Missing Document in request body",
            Some(&ProblemReport::new("Missing Document in request body")),
        )
    }
}
