//! Define `Unauthorized` response type.

use poem_openapi::{Object, types::Example};
use uuid::Uuid;

use crate::service::common;

#[derive(Object)]
#[oai(example)]
// Keep this message consistent with the response comment.
/// The client has not sent valid authentication credentials for the requested
/// resource.
pub(crate) struct Unauthorized {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: common::types::generic::error_uuid::ErrorUuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    msg: common::types::generic::error_msg::ErrorMessage,
}

impl Unauthorized {
    /// Create a new Payload.
    pub(crate) fn new(msg: String) -> Self {
        let id = Uuid::new_v4();

        Self {
            id: id.into(),
            msg: msg.into(),
        }
    }
}

impl Example for Unauthorized {
    /// Example
    fn example() -> Self {
        Self::new("Your request was not successful because it lacks valid authentication credentials for the requested resource.".to_string())
    }
}
