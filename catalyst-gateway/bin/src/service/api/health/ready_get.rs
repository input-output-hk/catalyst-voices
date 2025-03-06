//! Implementation of the GET /health/ready endpoint
use poem_openapi::ApiResponse;

use crate::{
    db::{event::establish_connection, index::session::CassandraSession},
    service::{
        common::{responses::WithErrorResponses, types::headers::retry_after::RetryAfterOption},
        utilities::health::{event_db_is_live, index_db_is_live},
    },
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## No Content
    ///
    /// Service is Started and can serve requests.
    #[oai(status = 204)]
    NoContent,
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
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    let error = AllResponses::service_unavailable(
        &anyhow::anyhow!("Service is not ready, do not send other requests."),
        RetryAfterOption::Default,
    );
    if !event_db_is_live() {
        // Attempt to reconnect
        establish_connection();
        return error;
    }
    if !index_db_is_live() {
        // Attempt to reconnect
        CassandraSession::init();
        return error;
    }
    Responses::NoContent.into()
}
