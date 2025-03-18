//! Implementation of the GET /health/ready endpoint
use poem_openapi::ApiResponse;
use tracing::error;

use crate::{
    cardano::index_db_is_ready,
    db::{
        event::{establish_connection, EventDB},
        index::session::CassandraSession,
    },
    service::{
        common::{responses::WithErrorResponses, types::headers::retry_after::RetryAfterOption},
        utilities::health::{event_db_is_live, index_db_is_live, set_event_db_liveness},
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
    // Check Event DB connection
    let event_db_live = event_db_is_live();

    // When check fails, attempt to re-connect
    if !event_db_live {
        establish_connection();
        // Re-check, and update Event DB service liveness flag
        set_event_db_liveness(EventDB::connection_is_ok());
    };

    // Check Index DB connection
    let index_db_live = index_db_is_live();

    // When check fails, attempt to re-connect
    if !index_db_live {
        CassandraSession::init();
        // Re-check, if success, enable flag.
        if !index_db_is_ready().await {
            error!("Index DB re-connection failed readiness check");
        }
    }

    let success_response = Responses::NoContent.into();

    // Return 204 response if check passed initially.
    if index_db_live && event_db_live {
        return success_response;
    }

    // Otherwise, re-check, and return 204 response if all is good.
    if index_db_is_live() && event_db_is_live() {
        return success_response;
    }

    // Otherwise, return 503 response.
    AllResponses::service_unavailable(
        &anyhow::anyhow!("Service is not ready, do not send other requests."),
        RetryAfterOption::Default,
    )
}
