//! Define `Unauthorized` response type.

use poem_openapi::{types::Example, Object};
use uuid::Uuid;

use crate::service::common;

#[derive(Object)]
#[oai(example)]
// Keep this message consistent with the response comment.
/// The client has not sent valid authentication credentials for the requested
/// resource.
pub(crate) struct Unauthorized {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: Uuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    //#[oai(validator(max_length = "1000", pattern = "^[0-9a-zA-Z].*$"))]
    msg: common::types::generic::error_msg::ErrorMessage,
}

impl Unauthorized {
    /// Create a new Payload.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let msg = msg.unwrap_or(
            "Your request was not successful because it lacks valid authentication credentials for the requested resource.".to_string(),
        );
        let id = Uuid::new_v4();

        Self {
            id,
            msg: msg.into(),
        }
    }
}

impl Example for Unauthorized {
    /// Example
    fn example() -> Self {
        Self::new(None)
    }
}
