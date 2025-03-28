//! # Implementation of the GET /health/ready endpoint
//!
//! This module provides an HTTP endpoint to monitor the readiness of the service's
//! database connections and attempt to reconnect to any databases that are not currently
//! live. It uses the `LIVE_INDEX_DB` and `LIVE_EVENT_DB` atomic booleans defined in the
//! parent module to track the status of the Index DB and Event DB, respectively.
//!
//! ## Key Features
//!
//! 1. **Reconnection Logic**:
//!    - If either `LIVE_INDEX_DB` or `LIVE_EVENT_DB` is `false`, the service will attempt
//!      to reconnect to the corresponding database.
//!    - If the reconnection attempt is successful, the respective flag (`LIVE_INDEX_DB`
//!      or `LIVE_EVENT_DB`) is set to `true`.
//!    - If the reconnection attempt fails, the flag remains `false`.
//!
//! 2. **Readiness Check Logic**:
//!    - After attempting to reconnect to any non-live databases, the endpoint checks the
//!      status of both `LIVE_INDEX_DB` and `LIVE_EVENT_DB`.
//!    - If both flags are `true`, the endpoint returns a `204 No Content` response,
//!      indicating that all databases are live and the service is healthy.
//!    - If either flag is `false`, the endpoint returns a `503 Service Unavailable`
//!      response, indicating that at least one database is not live and the service is
//!      unhealthy.
//!
//! ## How It Works
//!
//! - When the endpoint is called, it first checks the status of `LIVE_INDEX_DB` and
//!   `LIVE_EVENT_DB`.
//! - For any database that is not live (i.e., its flag is `false`), the service attempts
//!   to reconnect to that database.
//! - If the reconnection attempt is successful, the corresponding flag is set to `true`.
//! - After attempting to reconnect, the endpoint checks the status of both flags:
//!   - If both `LIVE_INDEX_DB` and `LIVE_EVENT_DB` are `true`, the endpoint returns `204
//!     No Content`.
//!   - If either flag is `false`, the endpoint returns `503 Service Unavailable`.
//!
//! ## Example Scenarios
//!
//! 1. **Both Databases Live**:
//!    - `LIVE_INDEX_DB` and `LIVE_EVENT_DB` are both `true`.
//!    - No reconnection attempts are made.
//!    - The endpoint returns `204 No Content`.
//!
//! 2. **Index DB Not Live, Reconnection Successful**:
//!    - `LIVE_INDEX_DB` is `false`, and `LIVE_EVENT_DB` is `true`.
//!    - The service attempts to reconnect to the Index DB and succeeds.
//!    - `LIVE_INDEX_DB` is set to `true`.
//!    - The endpoint returns `204 No Content`.
//!
//! 3. **Event DB Not Live, Reconnection Fails**:
//!    - `LIVE_INDEX_DB` is `true`, and `LIVE_EVENT_DB` is `false`.
//!    - The service attempts to reconnect to the Event DB but fails.
//!    - `LIVE_EVENT_DB` remains `false`.
//!    - The endpoint returns `503 Service Unavailable`.
//!
//! 4. **Both Databases Not Live, Reconnection Partially Successful**:
//!    - `LIVE_INDEX_DB` and `LIVE_EVENT_DB` are both `false`.
//!    - The service attempts to reconnect to both databases.
//!    - Reconnection to the Index DB succeeds (`LIVE_INDEX_DB` is set to `true`), but
//!      reconnection to the Event DB fails (`LIVE_EVENT_DB` remains `false`).
//!    - The endpoint returns `503 Service Unavailable`.
//!
//! ## Notes
//!
//! - The reconnection logic ensures that the service actively attempts to restore
//!   connectivity to any non-live databases, improving robustness and reliability.
//! - The atomic booleans (`LIVE_INDEX_DB` and `LIVE_EVENT_DB`) are thread-safe, allowing
//!   concurrent access without issues.
//! - This endpoint is useful for monitoring and automatically recovering from transient
//!   database connectivity issues, ensuring that the service remains operational whenever
//!   possible.
//!
//! This endpoint complements the initialization and readiness monitoring endpoints by
//! providing ongoing connectivity checks and recovery attempts for the service's
//! databases.
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
        // Re-check connection to Indexing DB (internally updates the liveness flag)
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
