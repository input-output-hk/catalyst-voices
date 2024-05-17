//! Generic Responses are all contained in their own modules, grouped by response codes.

use poem::IntoResponse;
use poem_openapi::{
    payload::Json,
    registry::{MetaResponses, Registry},
    ApiResponse,
};

use super::objects::{server_error::ServerError, validation_error::ValidationError};

/// Bad Request response
#[derive(ApiResponse)]
#[oai(bad_request_handler = Self::poem_bad_request_handler)]
pub(crate) enum BadRequestResponse {
    /// ## Content validation error.
    ///
    /// This error means that the request was malformed.
    /// It has failed to pass validation, as specified by the `OpenAPI` schema.
    #[oai(status = 400)]
    BadRequest(Json<ValidationError>),
}

impl BadRequestResponse {
    /// Create a new `BadRequestResponse` from an `anyhow::Error`.
    pub(crate) fn new(err: &anyhow::Error) -> Self {
        Self::BadRequest(Json(ValidationError::new(err.to_string())))
    }

    /// Custom poem bad request handler
    #[allow(clippy::needless_pass_by_value)]
    fn poem_bad_request_handler(err: poem::Error) -> Self {
        Self::BadRequest(Json(ValidationError::new(err.to_string())))
    }
}

/// Internal Server Error response
#[derive(ApiResponse)]
pub(crate) enum InternalServerErrorResponse {
    /// ## Internal Server Error.
    ///
    /// An internal server error occurred.
    ///
    /// *The contents of this response should be reported to the projects issue tracker.*
    #[oai(status = 500)]
    ServerError(Json<ServerError>),
}

impl InternalServerErrorResponse {
    /// Create a new `InternalServerErrorResponse` from an `anyhow::Error`.
    pub(crate) fn new(err_msg: &anyhow::Error) -> Self {
        let error = ServerError::new(None);
        let id = error.id();
        tracing::error!(id = format!("{id}"), "{}", err_msg);
        Self::ServerError(Json(error))
    }
}

/// Default error responses
#[derive(ApiResponse)]
pub(crate) enum ServiceUnavailableResponse {
    /// ## Service Unavailable
    ///
    /// The service is not available, do not send other requests.
    ///
    /// *This is returned when the service either has not started,
    /// or has become unavailable.*
    #[oai(status = 503)]
    ServiceUnavailable,
}

impl ServiceUnavailableResponse {
    /// Create a new `ServiceUnavailableResponse`
    pub(crate) fn new() -> Self {
        Self::ServiceUnavailable
    }
}

/// Combined response type
pub(crate) enum CombinedResponse<T1, T2> {
    /// `T1` response
    T1(T1),
    /// `T2` response
    T2(T2),
}

/// Combined provided response type with the default error responses
pub(crate) type WithBadRequestAndInternalServerErrorResponse<T> =
    CombinedResponse<T, CombinedResponse<BadRequestResponse, InternalServerErrorResponse>>;

impl<T> From<T> for WithBadRequestAndInternalServerErrorResponse<T> {
    fn from(val: T) -> Self {
        Self::T1(val)
    }
}

impl<T> WithBadRequestAndInternalServerErrorResponse<T> {
    /// Build internal server error response
    pub(crate) fn internal_server_error(err: &anyhow::Error) -> Self {
        let resp = InternalServerErrorResponse::new(err);
        Self::T2(CombinedResponse::T2(resp))
    }
}

/// Combined provided response type with the default error responses under one type.
pub(crate) type WithAllErrorResponse<T> = CombinedResponse<
    T,
    CombinedResponse<
        BadRequestResponse,
        CombinedResponse<InternalServerErrorResponse, ServiceUnavailableResponse>,
    >,
>;

impl<T> From<T> for WithAllErrorResponse<T> {
    fn from(val: T) -> Self {
        Self::T1(val)
    }
}

impl<T> WithAllErrorResponse<T> {
    /// Build bad request response
    pub(crate) fn bad_request(err: &anyhow::Error) -> Self {
        let resp = BadRequestResponse::new(err);
        Self::T2(CombinedResponse::T1(resp))
    }

    /// Build internal server error response
    pub(crate) fn internal_server_error(err: &anyhow::Error) -> Self {
        let resp = InternalServerErrorResponse::new(err);
        Self::T2(CombinedResponse::T2(CombinedResponse::T1(resp)))
    }

    /// Build service unavailable response
    pub(crate) fn service_unavailable() -> Self {
        let resp = ServiceUnavailableResponse::new();
        Self::T2(CombinedResponse::T2(CombinedResponse::T2(resp)))
    }
}

impl<T1: ApiResponse, T2: ApiResponse> ApiResponse for CombinedResponse<T1, T2> {
    const BAD_REQUEST_HANDLER: bool = T1::BAD_REQUEST_HANDLER || T2::BAD_REQUEST_HANDLER;

    fn meta() -> MetaResponses {
        let t1_meta = T1::meta();
        let t2_meta = T2::meta();

        let responses = t1_meta
            .responses
            .into_iter()
            .chain(t2_meta.responses)
            .collect();
        MetaResponses { responses }
    }

    fn register(registry: &mut Registry) {
        T1::register(registry);
        T2::register(registry);
    }

    fn from_parse_request_error(err: poem::Error) -> Self {
        if T1::BAD_REQUEST_HANDLER {
            Self::T1(T1::from_parse_request_error(err))
        } else {
            Self::T2(T2::from_parse_request_error(err))
        }
    }
}

impl<T1: IntoResponse + Send, T2: IntoResponse + Send> IntoResponse for CombinedResponse<T1, T2> {
    fn into_response(self) -> poem::Response {
        match self {
            Self::T1(t1) => t1.into_response(),
            Self::T2(t2) => t2.into_response(),
        }
    }
}
