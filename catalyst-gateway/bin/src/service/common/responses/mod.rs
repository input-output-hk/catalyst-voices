//! Generic Responses are all contained in their own modules, grouped by response codes.

use poem::IntoResponse;
use poem_openapi::{
    payload::Json,
    registry::{MetaResponses, Registry},
    ApiResponse,
};

use super::objects::{server_error::ServerError, validation_error::ValidationError};

/// Default error responses
#[derive(ApiResponse)]
pub(crate) enum ErrorResponses {
    /// Content validation error.
    #[oai(status = 400)]
    BadRequest(Json<ValidationError>),
    /// Internal Server Error.
    ///
    /// *The contents of this response should be reported to the projects issue tracker.*
    #[oai(status = 500)]
    ServerError(Json<ServerError>),
    /// Service is not ready, do not send other requests.
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
    /// Handle a 5xx response.
    /// Returns a Server Error or a Service Unavailable response.
    /// Logging error message.
    pub(crate) fn handle_5xx_response(err: &anyhow::Error) -> Self {
        if err.is::<bb8::RunError<tokio_postgres::Error>>() {
            WithErrorResponses::Error(ErrorResponses::ServiceUnavailable)
        } else {
            let error = crate::service::common::objects::server_error::ServerError::new(None);
            let id = error.id();
            tracing::error!(id = format!("{id}"), "{}", err);
            WithErrorResponses::Error(ErrorResponses::ServerError(Json(error)))
        }
    }
}

impl<T: ApiResponse> From<T> for WithErrorResponses<T> {
    fn from(val: T) -> Self {
        Self::With(val)
    }
}

impl<T: ApiResponse> From<ValidationError> for WithErrorResponses<T> {
    fn from(val: ValidationError) -> Self {
        Self::Error(ErrorResponses::BadRequest(Json(val)))
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
