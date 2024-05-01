//! Generic Responses are all contained in their own modules, grouped by response codes.

/// Handle a 5xx response.
/// Returns a Server Error or a Service Unavailable response.
/// Logging error message.
/// Argument must be `anyhow::Error` type.
macro_rules! handle_5xx_response {
    ($err:ident) => {{
        if $err.is::<bb8::RunError<tokio_postgres::Error>>() {
            AllResponses::ServiceUnavailable
        } else {
            let error = crate::service::common::objects::server_error::ServerError::new(None);
            let id = error.id();
            tracing::error!(id = format!("{id}"), "{}", $err);
            AllResponses::ServerError(Json(error))
        }
    }};
}
pub(crate) use handle_5xx_response;
