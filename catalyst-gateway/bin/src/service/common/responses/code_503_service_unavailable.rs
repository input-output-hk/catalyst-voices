//! Define `Service Unavailable` Response Body.

use poem_openapi::{types::Example, Object};
use uuid::Uuid;

use crate::service::common;

#[derive(Object)]
#[oai(example)]
/// The service is not available, try again later.
///
/// *This is returned when the service either has not started,
/// or has become unavailable.*
pub(crate) struct ServiceUnavailable {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: common::types::generic::error_uuid::ErrorUuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    msg: String,
}

impl ServiceUnavailable {
    /// Create a new Server Error Response Payload.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let msg = msg.unwrap_or(
            "Service Unavailable. Indicates that the server is not ready to handle the request."
                .to_string(),
        );
        let id = Uuid::new_v4();

        Self { id: id.into(), msg }
    }

    /// Get the id of this Server Error.
    pub(crate) fn id(&self) -> Uuid {
        self.id.clone().into()
    }
}

impl Example for ServiceUnavailable {
    /// Example for the Service Unavailable Payload.
    fn example() -> Self {
        Self::new(None)
    }
}
