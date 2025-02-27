//! Utilities used for system `Started` functionality.

use std::sync::atomic::{
    AtomicBool,
    Ordering::{Acquire, Release},
};

/// Flag to determine if the service has started
static STARTED: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the service has started.
static LIVE_INDEX_DB: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the service has started.
static LIVE_EVENT_DB: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the chain follower has synchronized with the Tip for the first
/// time.
static INITIAL_FOLLOWER_TIP_REACHED: AtomicBool = AtomicBool::new(false);

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
    event_db_is_live() && index_db_is_live() && follower_has_first_reached_tip()
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

/// Returns whether the Chain Follower has reached Tip or not.
///
/// Gets the stored value from `INITIAL_FOLLOWER_TIP_REACHED` flag.
pub(crate) fn follower_has_first_reached_tip() -> bool {
    INITIAL_FOLLOWER_TIP_REACHED.load(Acquire)
}

/// Set the `INITIAL_FOLLOWER_TIP_REACHED` as `true`.
///
/// This value can not be set to `false` afterwards.
pub(crate) fn set_follower_first_reached_tip() {
    INITIAL_FOLLOWER_TIP_REACHED.store(true, Release);
}
