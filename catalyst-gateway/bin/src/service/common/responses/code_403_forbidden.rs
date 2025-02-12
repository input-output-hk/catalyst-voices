//! Define `Forbidden` response type.

use poem_openapi::{types::Example, Object};
use uuid::Uuid;

use crate::service::common;

#[derive(Object)]
#[oai(example)]
/// The client has not sent valid authentication credentials for the requested
/// resource.
pub(crate) struct Forbidden {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: common::types::generic::error_uuid::ErrorUuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    #[oai(validator(max_length = "1000", pattern = "^[0-9a-zA-Z].*$"))]
    msg: String,
    /// List or Roles required to access the resource.
    // TODO: This should be a Vector of defined Roles/Grants.
    // When those are defined, use that type instead of "String"
    // It should look like an enum.
    #[oai(validator(max_items = 100, max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    required: Option<Vec<String>>,
}

impl Forbidden {
    /// Create a new Server Error Response Payload.
    pub(crate) fn new(msg: Option<String>, roles: Option<Vec<String>>) -> Self {
        let msg = msg.unwrap_or(
            "Your request was not successful because your authentication credentials do not have the required roles for the requested resource.".to_string(),
        );
        let id = Uuid::new_v4();

        Self {
            id: id.into(),
            msg,
            required: roles,
        }
    }
}

impl Example for Forbidden {
    /// Example for the Too Many Requests Payload.
    fn example() -> Self {
        Self::new(
            None,
            Some(vec!["VOTER".to_string(), "PROPOSER".to_string()]),
        )
    }
}
