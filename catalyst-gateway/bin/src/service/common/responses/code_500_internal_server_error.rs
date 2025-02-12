//! Define `ServerError` type.

use poem_openapi::{types::Example, Object};
use uuid::Uuid;

/// While using macro-vis lib, you will get the `uncommon_codepoints` warning, so you will
/// probably want to place this in your crate root
use crate::{service::common, settings::Settings};

#[derive(Object)]
#[oai(example, skip_serializing_if_is_none)]
/// An internal server error occurred.
///
/// *The contents of this response should be reported to the projects issue tracker.*
pub(crate) struct InternalServerError {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: common::types::generic::error_uuid::ErrorUuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    msg: common::types::generic::error_msg::ErrorMessage,
    /// A URL to report an issue.
    issue: Option<common::types::generic::url::Url>,
}

impl InternalServerError {
    /// Create a new Server Error Response Payload.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let msg = msg.unwrap_or(
            "Internal Server Error.  Please report the issue to the service owner.".to_string(),
        );
        let id = Uuid::new_v4();
        let issue_title = format!("Internal Server Error - {id}");
        let issue = Settings::generate_github_issue_url(&issue_title);

        Self {
            id: id.into(),
            msg: msg.into(),
            issue: issue.map(Into::into),
        }
    }

    /// Get the id of this Server Error.
    pub(crate) fn id(&self) -> Uuid {
        self.id.clone().into()
    }
}

impl Example for InternalServerError {
    /// Example for the Server Error Payload.
    fn example() -> Self {
        Self::new(None)
    }
}
