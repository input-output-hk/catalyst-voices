//! Implementation of the GET /health/ready endpoint
use poem_openapi::ApiResponse;

use crate::{
    db::event::{schema_check::MismatchedSchemaError, EventDB},
    service::common::responses::WithErrorResponses,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Service is Started and can serve requests.
    #[oai(status = 204)]
    NoContent,
    /// Service is not ready, do not send other requests.
    #[oai(status = 503)]
    ServiceUnavailable,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET /health/ready
///
/// Readiness endpoint.
///
/// Kubernetes (and others) use this endpoint to determine if the service is
/// able to service requests.
///
/// In this service, readiness is guaranteed if this endpoint is reachable.
/// So, it will always just return 204.
///
/// In theory it can also return 503 if for some reason a temporary circumstance
/// is preventing this service from properly serving request.
///
/// An example could be the service has started a long and cpu intensive task
/// and is not able to properly service requests while it is occurring.
/// This would let the load balancer shift traffic to other instances of this
/// service that are ready.
pub(crate) async fn endpoint() -> AllResponses {
    match EventDB::schema_version_check().await {
        Ok(_) => {
            tracing::debug!("DB schema version status ok");
            Responses::NoContent.into()
        },
        Err(err) if err.is::<MismatchedSchemaError>() => {
            tracing::error!("{err}");
            Responses::ServiceUnavailable.into()
        },
        Err(err) => AllResponses::handle_error(&err),
    }
}
