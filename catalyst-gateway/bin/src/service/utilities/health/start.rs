//! Utilities used for system `Started` functionality.

use std::sync::atomic::{
    AtomicBool,
    Ordering::{Acquire, Release},
};

/// Flag to determine if the service has started
static STARTED: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the service has started
static LIVE_INDEX_DB: AtomicBool = AtomicBool::new(false);

/// Flag to determine if the service has started
static LIVE_EVENT_DB: AtomicBool = AtomicBool::new(false);

/// Returns whether the service has started or not.
///
/// Gets the stored value from `STARTED` flag.
pub(crate) fn service_has_started() -> bool {
    STARTED.load(Acquire)
}

/// Set the `STARTED` flag to `true`
pub(crate) fn set_to_started() {
    STARTED.store(true, Release);
}

/// Returns whether the Event DB is live or not.
///
/// Gets the stored value from `LIVE_EVENT_DB` flag.
pub(crate) fn event_db_is_live() -> bool {
    LIVE_EVENT_DB.load(Acquire)
}

/// Set the `LIVE_EVENT_DB` flag
pub(crate) fn set_event_db_liveness(flag: bool) {
    LIVE_EVENT_DB.store(flag, Release);
}

/// Returns whether the Index DB is live or not.
///
/// Gets the stored value from `LIVE_INDEX_DB` flag.
pub(crate) fn index_db_is_live() -> bool {
    LIVE_INDEX_DB.load(Acquire)
}

/// Set the `LIVE_INDEX_DB` flag
pub(crate) fn set_index_db_liveness(flag: bool) {
    LIVE_INDEX_DB.store(flag, Release);
}
