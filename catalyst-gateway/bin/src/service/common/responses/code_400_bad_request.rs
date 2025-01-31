//! Define `Bad Request` response type.

use poem::IntoResponse;
use poem_openapi::{
    payload::{Json, Payload},
    registry::{MetaSchema, MetaSchemaRef},
    types::Example,
    Object, ResponseContent,
};

use crate::service::common;

/// Bad Request response content
#[derive(ResponseContent)]
pub(crate) enum BadRequestResponse {
    /// Bad Request response without body
    #[allow(dead_code)]
    EmptyBody(EmptyPayload),
    /// Bad Request response with body
    WithBody(Json<BadRequest>),
}

/// The client has not sent valid request, could be an invalid HTTP in general or provided
/// not correct headers, path or query arguments.
#[derive(Object)]
#[oai(example)]
pub(crate) struct BadRequest {
    /// Detailed error message.
    #[oai(validator(max_length = "1000", pattern = "^[0-9a-zA-Z].*$"))]
    error: common::types::generic::error_msg::ErrorMessage,
}

impl BadRequestResponse {
    /// Create a new `BadRequest` Response Payload.
    pub(crate) fn new(error: &poem::Error) -> Self {
        Self::WithBody(Json(BadRequest {
            error: error.to_string().into(),
        }))
    }
}

impl Example for BadRequest {
    fn example() -> Self {
        Self {
            error: Example::example(),
        }
    }
}

/// An empty payload.
#[derive(Debug, Clone, Eq, PartialEq)]
pub(crate) struct EmptyPayload;

impl Payload for EmptyPayload {
    const CONTENT_TYPE: &'static str = "";

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new("null")))
    }
}

impl IntoResponse for EmptyPayload {
    fn into_response(self) -> poem::Response {
        ().into_response()
    }
}
