//! Generic Responses are all contained in their own modules, grouped by response codes.

use std::{
    collections::HashSet,
    hash::{Hash, Hasher},
};

use poem::IntoResponse;
use poem_openapi::{
    payload::Json,
    registry::{MetaResponse, MetaResponses, Registry},
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
            err if err.is::<bb8::RunError<tokio_postgres::Error>>() => {
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

        let mut responses = HashSet::new();
        responses.extend(
            t_meta
                .responses
                .into_iter()
                .map(FilteredByStatusCodeResponse),
        );
        responses.extend(
            default_meta
                .responses
                .into_iter()
                .map(FilteredByStatusCodeResponse),
        );

        let responses = responses.into_iter().map(|val| val.0).collect();
        MetaResponses { responses }
    }

    fn register(registry: &mut Registry) {
        ErrorResponses::register(registry);
        T::register(registry);
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

/// `FilteredByStatusCodeResponse` is used to filter out duplicate responses by status
/// code.
struct FilteredByStatusCodeResponse(MetaResponse);

impl PartialEq for FilteredByStatusCodeResponse {
    fn eq(&self, other: &Self) -> bool {
        self.0.status.eq(&other.0.status)
    }
}
impl Eq for FilteredByStatusCodeResponse {}
impl Hash for FilteredByStatusCodeResponse {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.0.status.hash(state);
    }
}
