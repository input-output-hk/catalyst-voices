//! Define `Forbidden` response type.

use poem_openapi::{
    types::{Example, ToJSON},
    Object,
};
use uuid::Uuid;

use crate::service::{common, common::types::array_types::impl_array_types};

#[derive(Object)]
#[oai(example)]
/// The client has not sent valid authentication credentials for the requested
/// resource.
pub(crate) struct Forbidden {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: common::types::generic::error_uuid::ErrorUuid,
    /// Error message.
    // Will not contain sensitive information, internal details or backtraces.
    msg: common::types::generic::error_msg::ErrorMessage,
    /// List or Roles required to access the resource.
    // TODO: This should be a Vector of defined Roles/Grants.
    // When those are defined, use that type instead of "String"
    // It should look like an enum.
    required: Option<RoleList>,
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
            msg: msg.into(),
            required: roles.map(Into::into),
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

// List of roles
impl_array_types!(
    RoleList,
    String,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(poem_openapi::registry::MetaSchemaRef::Inline(
            Box::new(poem_openapi::registry::MetaSchema::new("string").merge(
                poem_openapi::registry::MetaSchema {
                    max_length: Some(100),
                    pattern: Some("^[0-9a-zA-Z].*$".into()),
                    ..poem_openapi::registry::MetaSchema::ANY
                }
            ))
        ))),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for RoleList {
    fn example() -> Self {
        Self(vec!["VOTER".to_string(), "PROPOSER".to_string()])
    }
}
