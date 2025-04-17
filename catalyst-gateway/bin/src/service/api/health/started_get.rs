//! # Implementation of the GET /health/started endpoint
//!
//! This module provides an HTTP endpoint to monitor the start of the Cat Gateway
//! service, which depends on multiple parameters. It uses atomic booleans to track the
//! status of the service and its dependencies.
//!
//! ## Key Features
//!
//! 1. **Atomic Booleans for Initialization**:
//!    - `STARTED`: Indicates whether the service has fully initialized. It defaults to
//!      `false` on startup and can only transition to `true` once all required conditions
//!      are met. Once set to `true`, it cannot be changed back to `false`.
//!    - `LIVE_INDEX_DB` and `LIVE_EVENT_DB`: Track the connection status of the Index DB
//!      and Event DB, respectively. Both default to `false` on startup and are set to
//!      `true` once a successful connection is established.
//!    - A third atomic boolean (e.g., `INITIAL_FOLLOWER_TIP_REACHED`) is used to track
//!      whether the chain indexer has reached the tip of the chain for the first time.
//!      This also defaults to `false` and is set to `true` once the condition is met.
//!
//! 2. **Initialization Logic**:
//!    - On startup, the service attempts to connect to both databases (Index DB and Event
//!      DB). It will keep retrying until both connections are successful. Once both
//!      databases are connected, their respective flags (`LIVE_INDEX_DB` and
//!      `LIVE_EVENT_DB`) are set to `true`.
//!    - The `STARTED` flag is set to `true` only when all three conditions are met
//!      simultaneously:
//!       1. `LIVE_INDEX_DB` is `true`.
//!       2. `LIVE_EVENT_DB` is `true`.
//!       3. `INITIAL_FOLLOWER_TIP_REACHED` is `true`.
//!    - Once `STARTED` is set to `true`, it cannot be changed back to `false`.
//!
//! 3. **Response Logic**:
//!    - If `STARTED` is `true`, the endpoint returns a `204 No Content` response,
//!      indicating that the service is fully initialized and operational.
//!    - If `STARTED` is `false`, the endpoint returns a `503 Service Unavailable`
//!      response, indicating that the service is not yet ready to handle requests.
//!
//! ## How It Works
//!
//! - On startup, the service attempts to connect to the Index DB and Event DB. It retries
//!   until both connections are successful. Once connected, their respective flags
//!   (`LIVE_INDEX_DB` and `LIVE_EVENT_DB`) are set to `true`.
//! - The chain indexer monitors the blockchain and sets `INITIAL_FOLLOWER_TIP_REACHED` to
//!   `true` once it reaches the tip of the chain for the first time.
//! - When all three flags (`LIVE_INDEX_DB`, `LIVE_EVENT_DB`, and
//!   `INITIAL_FOLLOWER_TIP_REACHED`) are `true`, the `STARTED` flag is set to `true`.
//! - Once `STARTED` is `true`, the endpoint will always respond with `204 No Content`.
//! - If `STARTED` is `false`, the endpoint will respond with `503 Service Unavailable`.
//!
//! ## Example Scenarios
//!
//! 1. **Startup Phase**:
//!    - The service is starting up.
//!    - `LIVE_INDEX_DB`, `LIVE_EVENT_DB`, and `INITIAL_FOLLOWER_TIP_REACHED` are all
//!      `false`.
//!    - `STARTED` is `false`.
//!    - The endpoint returns `503 Service Unavailable`.
//!
//! 2. **Databases Connected, Indexer Not Ready**:
//!    - The Index DB and Event DB are connected (`LIVE_INDEX_DB` and `LIVE_EVENT_DB` are
//!      `true`).
//!    - The chain indexer has not yet reached the tip of the chain
//!      (`INITIAL_FOLLOWER_TIP_REACHED` is `false`).
//!    - `STARTED` is `false`.
//!    - The endpoint returns `503 Service Unavailable`.
//!
//! 3. **All Conditions Met**:
//!    - The Index DB and Event DB are connected (`LIVE_INDEX_DB` and `LIVE_EVENT_DB` are
//!      `true`).
//!    - The chain indexer has reached the tip of the chain
//!      (`INITIAL_FOLLOWER_TIP_REACHED` is `true`).
//!    - `STARTED` is set to `true`.
//!    - The endpoint returns `204 No Content`.
//!
//! 4. **After Initialization**:
//!    - All flags (`LIVE_INDEX_DB`, `LIVE_EVENT_DB`, `INITIAL_FOLLOWER_TIP_REACHED`, and
//!      `STARTED`) are `true`.
//!    - The endpoint continues to return `204 No Content`.
//!
//! ## Notes
//!
//! - All booleans are atomic, meaning they are thread-safe and can be accessed
//!   concurrently without issues.
//! - Once `STARTED` is set to `true`, it cannot be reverted, ensuring that the service
//!   remains in a consistent state after initialization.
//!
//! This endpoint is useful for monitoring the initialization status of a service that
//! depends on multiple external systems, ensuring that the service only becomes available
//! once all dependencies are ready.

use poem_openapi::ApiResponse;

use crate::service::{
    common::{responses::WithErrorResponses, types::headers::retry_after::RetryAfterOption},
    utilities::health::service_has_started,
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

/// # GET /health/started
///
/// Service Started endpoint.
///
/// Kubernetes (and others) use this endpoint to determine if the service has started
/// properly and is able to serve requests.
///
/// In this service, started is guaranteed if this endpoint is reachable.
/// So, it will always just return 204.
///
/// In theory it can also return 503 is the service has some startup processing
/// to complete before it is ready to serve requests.
///
/// An example of not being started could be that bulk data needs to be read
/// into memory or processed in some way before the API can return valid
/// responses.  In that scenario this endpoint would return 503 until that
/// startup processing was fully completed.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    if service_has_started() {
        Responses::NoContent.into()
    } else {
        AllResponses::service_unavailable(
            &anyhow::anyhow!("Service is not ready, do not send other requests."),
            RetryAfterOption::Default,
        )
    }
}
