//! Define `TooManyRequests` response type.

use poem_openapi::{types::Example, Object};
use uuid::Uuid;

use crate::service::common;

#[derive(Object)]
#[oai(example)]
/// The client has sent too many requests in a given amount of time.
pub(crate) struct TooManyRequests {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: common::types::generic::error_uuid::ErrorUuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    msg: common::types::generic::error_msg::ErrorMessage,
}

impl TooManyRequests {
    /// Create a new Server Error Response Payload.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let msg = msg.unwrap_or(
            "Too Many Requests. You have exceeded the rate limit for this endpoint.".to_string(),
        );
        let id = Uuid::new_v4();

        Self {
            id: id.into(),
            msg: msg.into(),
        }
    }
}

impl Example for TooManyRequests {
    /// Example for the Too Many Requests Payload.
    fn example() -> Self {
        Self::new(None)
    }
}
