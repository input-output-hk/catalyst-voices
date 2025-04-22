//! # Implementation of the `GET /health/live` endpoint.
//!
//! This module provides an HTTP endpoint to monitor the liveness of the API service using
//! a simple counter mechanism. It uses an atomic boolean named `IS_LIVE` to track whether
//! the service is operational. The `IS_LIVE` boolean is initially set to `true`.
//!
//! ## Key Features
//!
//! 1. **Atomic Counter**:   The endpoint maintains an atomic counter that increments
//!    every time the endpoint is accessed. This counter helps track the number of
//!    requests made to the endpoint.
//!
//! 2. **Counter Reset**:   Every 30 seconds, the counter is automatically reset to zero.
//!    This ensures that the count reflects recent activity rather than cumulative usage
//!    over a long period.
//!
//! 3. **Threshold Check**:   If the counter reaches a predefined threshold (e.g., 100),
//!    the `IS_LIVE` boolean is set to `false`. This indicates that the service is no
//!    longer operational. Once `IS_LIVE` is set to `false`, it cannot be changed back to
//!    `true`.
//!
//! 4. **Response Logic**:
//!    - If `IS_LIVE` is `true`, the endpoint returns a `204 No Content` response,
//!      indicating that the service is healthy and operational.
//!    - If `IS_LIVE` is `false`, the endpoint returns a `503 Service Unavailable`
//!      response, indicating that the service is no longer operational.
//!
//! ## How It Works
//!
//! - When the endpoint is called, the atomic counter increments by 1.
//! - Every 30 seconds, the counter is reset to 0 to ensure it only reflects recent
//!   activity.
//! - If the counter reaches the threshold (e.g., 100), the `IS_LIVE` boolean is set to
//!   `false`.
//! - Once `IS_LIVE` is `false`, the endpoint will always respond with `503 Service
//!   Unavailable`.
//! - If `IS_LIVE` is `true`, the endpoint responds with `204 No Content`.
//!
//! ## Example Scenarios
//!
//! 1. **Normal Operation**:
//!    - The counter is below the threshold.
//!    - `IS_LIVE` remains `true`.
//!    - The endpoint returns `204 No Content`.
//!
//! 2. **Threshold Exceeded**:
//!    - The counter reaches 100.
//!    - `IS_LIVE` is set to `false`.
//!    - The endpoint returns `503 Service Unavailable`.
//!
//! 3. **After Threshold Exceeded**:
//!    - The counter is reset to 0, but `IS_LIVE` remains `false`.
//!    - The endpoint continues to return `503 Service Unavailable`.
//!
//! ## Notes
//!
//! - The `IS_LIVE` boolean is atomic, meaning it is thread-safe and can be accessed
//!   concurrently without issues.
//!
//! This endpoint is useful for monitoring service liveness and automatically marking it
//! as unavailable if it becomes overloaded or encounters issues.

use poem_openapi::ApiResponse;

use crate::service::{
    common::{responses::WithErrorResponses, types::headers::retry_after::RetryAfterOption},
    utilities::health::is_live,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## No Content
    ///
    /// Service is OK and can keep running.
    #[oai(status = 204)]
    NoContent,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET /health/live
///
/// Liveness endpoint.
///
/// Kubernetes (and others) use this endpoint to determine if the service is able
/// to keep running.
///
/// In this service, liveness is assumed unless there are multiple panics generated
/// by an endpoint in a short window.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    if is_live() {
        Responses::NoContent.into()
    } else {
        AllResponses::service_unavailable(
            &anyhow::anyhow!("Service is not live, do not send other requests."),
            RetryAfterOption::Default,
        )
    }
}
