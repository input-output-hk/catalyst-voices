//! This module contains common and re-usable responses with a 4xx response code.
use poem::{error::ResponseError, http::StatusCode};
use poem_extensions::OneResponse;
use poem_openapi::{payload::Json, types::Example, Object};
use url::Url;
use uuid::Uuid;

/// While using macro-vis lib, you will get the `uncommon_codepoints` warning, so you will
/// probably want to place this in your crate root
use crate::settings::generate_github_issue_url;

/// Handle a 5xx response.
/// Returns a Server Error or a Service Unavailable response.
/// Logging error message.
/// Argument must be `anyhow::Error` type.
macro_rules! handle_5xx_response {
    ($err:ident) => {{
        if $err.is::<bb8::RunError<tokio_postgres::Error>>() {
            poem_extensions::UniResponse::T503(ServiceUnavailable)
        } else {
            let error = crate::service::common::responses::resp_5xx::ServerError::new(None);
            let id = error.id();
            tracing::error!(id = format!("{id}"), "{}", $err);
            poem_extensions::UniResponse::T500(error)
        }
    }};
}
pub(crate) use handle_5xx_response;

#[derive(Debug, Object)]
#[oai(example, skip_serializing_if_is_none)]
/// Response payload to a Bad request.
struct ServerErrorPayload {
    /// Unique ID of this Server Error so that it can be located easily for debugging.
    id: Uuid,
    /// *Optional* SHORT Error message.
    /// Will not contain sensitive information, internal details or backtraces.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(max_length = "100", pattern = "^[0-9a-zA-Z].*$"))]
    msg: Option<String>,
    /// A URL to report an issue.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(max_length = "1000"))]
    issue: Option<Url>,
}

impl ServerErrorPayload {
    /// Create a new Server Error Response Payload.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let id = Uuid::new_v4();
        let issue_title = format!("Internal Server Error - {id}");
        let issue = generate_github_issue_url(&issue_title);

        Self { id, msg, issue }
    }
}

impl Example for ServerErrorPayload {
    /// Example for the Server Error Payload.
    fn example() -> Self {
        Self::new(Some("Server Error".to_string()))
    }
}

#[derive(OneResponse)]
#[oai(status = 500)]
/// ## Internal Server Error
///
/// An internal server error occurred.
///
/// *The contents of this response should be reported to the projects issue tracker.*
pub(crate) struct ServerError(Json<ServerErrorPayload>);

impl ServerError {
    /// Create a new Server Error Response.
    pub(crate) fn new(msg: Option<String>) -> Self {
        let msg = msg.unwrap_or(
            "Internal Server Error.  Please report the issue to the service owner.".to_string(),
        );
        Self(Json(ServerErrorPayload::new(Some(msg))))
    }

    /// Get the id of this Server Error.
    pub(crate) fn id(&self) -> Uuid {
        self.0.id
    }
}

impl ResponseError for ServerError {
    fn status(&self) -> StatusCode {
        StatusCode::INTERNAL_SERVER_ERROR
    }
}

#[derive(OneResponse, Debug)]
#[oai(status = 503)]
/// ## Service Unavailable
///
/// The service is not available.
///
/// *This is returned when the service either has not started,
/// or has become unavailable.*
///
/// #### NO DATA BODY IS RETURNED FOR THIS RESPONSE
pub(crate) struct ServiceUnavailable;

impl ResponseError for ServiceUnavailable {
    fn status(&self) -> StatusCode {
        StatusCode::SERVICE_UNAVAILABLE
    }
}
