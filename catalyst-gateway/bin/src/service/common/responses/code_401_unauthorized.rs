//! Define `Unauthorized` response type.

use poem_openapi::{types::Example, Object};
use uuid::Uuid;

#[derive(Debug, Object)]
#[oai(example, skip_serializing_if_is_none)]
/// Server Error response to a Bad request.
pub(crate) struct Unauthorized {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: Uuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    #[oai(validator(max_length = "1000", pattern = "^[0-9a-zA-Z].*$"))]
    msg: String,
}

impl Unauthorized {
    /// Create a new Server Error Response Payload.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let msg = msg.unwrap_or(
            "Your request was not successful because it lacks valid authentication credentials for the requested resource.".to_string(),
        );
        let id = Uuid::new_v4();

        Self { id, msg }
    }
}

impl Example for Unauthorized {
    /// Example for the Too Many Requests Payload.
    fn example() -> Self {
        Self::new(None)
    }
}
