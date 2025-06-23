//! Utilities used for system `Started` functionality.

use std::sync::atomic::{
    AtomicBool,
    Ordering::{Acquire, Release},
};

use tracing::debug;

/// Flag to determine if the service has started
static STARTED: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the Indexing DB has started.
static LIVE_INDEX_DB: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the Event DB has started.
static LIVE_EVENT_DB: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the chain follower has synchronized with the IMMUTABLE tip for
/// the first time.
static INITIAL_IMMUTABLE_FOLLOWER_TIP_REACHED: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the chain follower has synchronized with the LIVE tip for the
/// first time.
static INITIAL_LIVE_FOLLOWER_TIP_REACHED: AtomicBool = AtomicBool::new(false);

/// Returns whether the service has started or not.
pub(crate) fn service_has_started() -> bool {
    STARTED.load(Acquire)
}

/// Set the `STARTED` flag to `true`
pub(crate) fn set_to_started() {
    STARTED.store(true, Release);
}

/// Returns whether the service has started or not.
pub(crate) fn condition_for_started() -> bool {
    let event_db = event_db_is_live();
    let index_db = index_db_is_live();
    let follower =
        live_follower_has_first_reached_tip() && immutable_follower_has_first_reached_tip();
    debug!("Checking if service has started. Event DB: {event_db}, Index DB: {index_db}, Follower: {follower}");
    event_db && index_db && follower
}

/// Returns whether the Event DB is live or not.
///
/// Gets the stored value from `LIVE_EVENT_DB` flag.
pub(crate) fn event_db_is_live() -> bool {
    LIVE_EVENT_DB.load(Acquire)
}

/// Set the `LIVE_EVENT_DB` flag.
pub(crate) fn set_event_db_liveness(flag: bool) {
    LIVE_EVENT_DB.store(flag, Release);
}

/// Returns whether the Index DB is live or not.
///
/// Gets the stored value from `LIVE_INDEX_DB` flag.
pub(crate) fn index_db_is_live() -> bool {
    LIVE_INDEX_DB.load(Acquire)
}

/// Set the `LIVE_INDEX_DB` flag.
pub(crate) fn set_index_db_liveness(flag: bool) {
    LIVE_INDEX_DB.store(flag, Release);
}

/// Returns whether the Chain Follower has reached Immutable Tip or not.
///
/// Gets the stored value from `INITIAL_IMMUTABLE_FOLLOWER_TIP_REACHED` flag.
pub(crate) fn immutable_follower_has_first_reached_tip() -> bool {
    INITIAL_IMMUTABLE_FOLLOWER_TIP_REACHED.load(Acquire)
}

/// Returns whether the Chain Follower has reached Live Tip or not.
///
/// Gets the stored value from `INITIAL_LIVE_FOLLOWER_TIP_REACHED` flag.
pub(crate) fn live_follower_has_first_reached_tip() -> bool {
    INITIAL_LIVE_FOLLOWER_TIP_REACHED.load(Acquire)
}

/// Set the `INITIAL_IMMUTABLE_FOLLOWER_TIP_REACHED` as `true`.
///
/// This value can not be set to `false` afterwards.
pub(crate) fn set_follower_immutable_first_reached_tip() {
    INITIAL_IMMUTABLE_FOLLOWER_TIP_REACHED.store(true, Release);
}

/// Set the `INITIAL_LIVE_FOLLOWER_TIP_REACHED` as `true`.
///
/// This value can not be set to `false` afterwards.
pub(crate) fn set_follower_live_first_reached_tip() {
    INITIAL_LIVE_FOLLOWER_TIP_REACHED.store(true, Release);
}
