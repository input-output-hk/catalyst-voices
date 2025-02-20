//! Implementation of the `GET /health/live` endpoint.

use std::sync::atomic::{AtomicBool, Ordering};

use atomic_counter::{AtomicCounter, ConsistentCounter};
use poem_openapi::ApiResponse;

use crate::{db::index::session::CassandraSession, service::common::responses::WithErrorResponses};

/// Flag to determine if the service is live.
///
/// Defaults to `true`.
static IS_LIVE: AtomicBool = AtomicBool::new(true);

/// Counter to determine if the service is live.
static LIVE_COUNTER: ConsistentCounter = ConsistentCounter::new(0);

/// Pre-defined threshold after which `IS_LIVE` is set to `false`.
const LIVE_COUNTER_THRESHOLD: usize = 100;

/// Get the `IS_LIVE` flag
pub(crate) fn is_live() -> bool {
    IS_LIVE.load(Ordering::Acquire) && CassandraSession::is_ready()
}

/// Set the `IS_LIVE` flag to `false`
pub(crate) fn set_not_live() {
    IS_LIVE.store(false, Ordering::Release);
}

/// Increment the `LIVE_COUNTER` by one.
pub(crate) fn live_counter_inc() -> usize {
    LIVE_COUNTER.inc()
}

/// Get the `LIVE_COUNTER` value.
pub(crate) fn live_counter_get() -> usize {
    LIVE_COUNTER.get()
}

/// Reset the `LIVE_COUNTER` to zero.
pub(crate) fn live_counter_reset() -> usize {
    LIVE_COUNTER.reset()
}

/// Returns `true` when `LIVE_COUNTER` is under the pre-defined threshold.
pub(crate) fn is_live_counter_under_threshold() -> bool {
    LIVE_COUNTER.get() < LIVE_COUNTER_THRESHOLD
}

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
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
    // TODO: Needs engineering discussion
    if is_live() {
        Responses::NoContent.into()
    } else {
        Responses::ServiceUnavailable.into()
    }
}
