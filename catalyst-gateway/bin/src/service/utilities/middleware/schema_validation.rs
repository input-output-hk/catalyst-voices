//! Middleware to verify the status of the last DB schema version validation.
//!
//! If a mismatch is detected, the middleware returns an error with `ServiceUnavailable`
//! status code (503). Otherwise, the middleware calls and returns the wrapped endpoint's
//! response.
//!
//! This middleware checks the `State.schema_version_status` value, if it is Ok,
//! the wrapped endpoint is called and its response is returned.

use poem::{http::StatusCode, Endpoint, EndpointExt, Middleware, Request, Result};
use tracing::error;

use crate::{
    db::event::{EventDB, EventDBConnectionError},
    service::utilities::health::set_event_db_liveness,
};

/// A middleware that raises an error  with `ServiceUnavailable` and 503 status code
/// if a DB schema version mismatch is found the existing `State`.
pub(crate) struct SchemaVersionValidation;

impl<E: Endpoint> Middleware<E> for SchemaVersionValidation {
    type Output = SchemaVersionValidationImpl<E>;

    fn transform(&self, ep: E) -> Self::Output {
        SchemaVersionValidationImpl { ep }
    }
}

/// The new endpoint type generated by the `SchemaVersionValidation`.
pub(crate) struct SchemaVersionValidationImpl<E> {
    /// Endpoint wrapped by the middleware.
    ep: E,
}

impl<E: Endpoint> Endpoint for SchemaVersionValidationImpl<E> {
    type Output = E::Output;

    async fn call(&self, req: Request) -> Result<Self::Output> {
        // Check if the inner schema version status is set to `Mismatch`,
        // if so, return the `StatusCode::SERVICE_UNAVAILABLE` code.
        if let Err(e) = EventDB::schema_version_check().await {
            if e.is::<EventDBConnectionError>() {
                set_event_db_liveness(false);
                error!("Event DB is disconnected. Liveness set to false");
            } else {
                error!("Schema version check error: {e:?}");
            }
            return Err(StatusCode::SERVICE_UNAVAILABLE.into());
        }
        // Calls the endpoint with the request, and returns the response.
        self.ep.call(req).await
    }
}

/// A function that wraps an endpoint with the `SchemaVersionValidation`.
///
/// This function is convenient to use with `poem-openapi` [operation parameters](https://docs.rs/poem-openapi/latest/poem_openapi/attr.OpenApi.html#operation-parameters) via the
/// `transform` attribute.
pub(crate) fn schema_version_validation(ep: impl Endpoint) -> impl Endpoint {
    ep.with(SchemaVersionValidation)
}
