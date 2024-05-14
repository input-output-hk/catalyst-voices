//! Generic Responses are all contained in their own modules, grouped by response codes.

use poem::IntoResponse;
use poem_openapi::{
    payload::Json,
    registry::{MetaResponses, Registry},
    ApiResponse,
};

use super::objects::{server_error::ServerError, validation_error::ValidationError};
use crate::service::utilities::NetworkValidationError;

/// Default error responses
#[derive(ApiResponse)]
pub(crate) enum ErrorResponses {
    /// ## Content validation error.
    ///
    /// This error means that the request was malformed.
    /// It has failed to pass validation, as specified by the `OpenAPI` schema.
    #[oai(status = 400)]
    BadRequest(Json<ValidationError>),
    /// ## Internal Server Error.
    ///
    /// An internal server error occurred.
    ///
    /// *The contents of this response should be reported to the projects issue tracker.*
    #[oai(status = 500)]
    ServerError(Json<ServerError>),
    /// ## Service Unavailable
    ///
    /// The service is not available, do not send other requests.
    ///
    /// *This is returned when the service either has not started,
    /// or has become unavailable.*
    #[oai(status = 503)]
    ServiceUnavailable,
}

/// Combine provided responses type with the default responses under one type.
pub(crate) enum WithErrorResponses<T> {
    /// Provided responses
    With(T),
    /// Error responses
    Error(ErrorResponses),
}

impl<T> WithErrorResponses<T> {
    /// Handle a 5xx or 4xx response.
    /// Returns a Server Error, a Bad Request or a Service Unavailable response.
    pub(crate) fn handle_error(err: &anyhow::Error) -> Self {
        match err {
            err if err.is::<NetworkValidationError>() => {
                WithErrorResponses::Error(ErrorResponses::BadRequest(Json(ValidationError::new(
                    err.to_string(),
                ))))
            },
            err if err.is::<NetworkValidationError>() => {
                WithErrorResponses::Error(ErrorResponses::ServiceUnavailable)
            },
            err => {
                let error = crate::service::common::objects::server_error::ServerError::new(None);
                let id = error.id();
                tracing::error!(id = format!("{id}"), "{}", err);
                WithErrorResponses::Error(ErrorResponses::ServerError(Json(error)))
            },
        }
    }
}

impl<T: ApiResponse> From<T> for WithErrorResponses<T> {
    fn from(val: T) -> Self {
        Self::With(val)
    }
}

impl<T: ApiResponse> ApiResponse for WithErrorResponses<T> {
    const BAD_REQUEST_HANDLER: bool = true;

    fn meta() -> MetaResponses {
        let t_meta = T::meta();
        let default_meta = ErrorResponses::meta();
        let responses = t_meta
            .responses
            .into_iter()
            .chain(default_meta.responses)
            .collect();
        MetaResponses { responses }
    }

    fn register(registry: &mut Registry) {
        T::register(registry);
        ErrorResponses::register(registry);
    }

    fn from_parse_request_error(err: poem::Error) -> Self {
        Self::Error(ErrorResponses::BadRequest(Json(ValidationError::new(
            err.to_string(),
        ))))
    }
}

impl<T: IntoResponse + Send> IntoResponse for WithErrorResponses<T> {
    fn into_response(self) -> poem::Response {
        match self {
            Self::With(t) => t.into_response(),
            Self::Error(default) => default.into_response(),
        }
    }
}
