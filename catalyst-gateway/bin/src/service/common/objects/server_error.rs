//! Define `ServerError` type.

use poem_openapi::{types::Example, Object};
use url::Url;
use uuid::Uuid;

/// While using macro-vis lib, you will get the `uncommon_codepoints` warning, so you will
/// probably want to place this in your crate root
use crate::settings::generate_github_issue_url;

#[derive(Debug, Object)]
#[oai(example, skip_serializing_if_is_none)]
/// Server Error response to a Bad request.
pub(crate) struct ServerError {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: Uuid,
    /// *Optional* SHORT Error message.
    /// Will not contain sensitive information, internal details or backtraces.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    msg: String,
    /// A URL to report an issue.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(max_length = "1000"))]
    issue: Option<Url>,
}

impl ServerError {
    /// Create a new Server Error Response Payload.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let msg = msg.unwrap_or(
            "Internal Server Error.  Please report the issue to the service owner.".to_string(),
        );
        let id = Uuid::new_v4();
        let issue_title = format!("Internal Server Error - {id}");
        let issue = generate_github_issue_url(&issue_title);

        Self { id, msg, issue }
    }

    /// Get the id of this Server Error.
    pub(crate) fn id(&self) -> Uuid {
        self.id
    }
}

impl Example for ServerError {
    /// Example for the Server Error Payload.
    fn example() -> Self {
        Self::new(Some("Server Error".to_string()))
    }
}
