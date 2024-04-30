//! Implementation of the GET /health/ready endpoint

use std::sync::Arc;

use poem::web::Data;
use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    event_db::schema_check::MismatchedSchemaError,
    service::common::{objects::server_error::ServerError, responses::handle_5xx_response},
    state::State,
};

/// All responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// Service is Started and can serve requests.
    #[oai(status = 204)]
    NoContent,
    /// Internal Server Error.
    ///
    /// *The contents of this response should be reported to the projects issue tracker.*
    #[oai(status = 500)]
    ServerError(Json<ServerError>),
    /// Service is not ready, do not send other requests.
    #[oai(status = 503)]
    ServiceUnavailable,
}

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
pub(crate) async fn endpoint(state: Data<&Arc<State>>) -> AllResponses {
    match state.event_db().schema_version_check().await {
        Ok(_) => {
            tracing::debug!("DB schema version status ok");
            AllResponses::NoContent
        },
        Err(err) if err.is::<MismatchedSchemaError>() => {
            tracing::error!("{err}");
            AllResponses::ServiceUnavailable
        },
        Err(err) => handle_5xx_response!(err),
    }
}
