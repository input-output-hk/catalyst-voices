//! Define `TooManyRequests` response type.

use poem_openapi::{types::Example, Object};
use uuid::Uuid;

#[derive(Object)]
#[oai(example)]
/// The client has sent too many requests in a given amount of time.
pub(crate) struct TooManyRequests {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: Uuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    msg: String,
}

impl TooManyRequests {
    /// Create a new Server Error Response Payload.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let msg = msg.unwrap_or(
            "Too Many Requests. You have exceeded the rate limit for this endpoint.".to_string(),
        );
        let id = Uuid::new_v4();

        Self { id, msg }
    }
}

impl Example for TooManyRequests {
    /// Example for the Too Many Requests Payload.
    fn example() -> Self {
        Self::new(None)
    }
}
