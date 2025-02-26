//! Utilities used for system `Started` functionality.

use std::sync::atomic::{AtomicBool, Ordering};

/// Flag to determine if the service has started
static IS_STARTED: AtomicBool = AtomicBool::new(false);

/// Set the started flag to `true`
pub(crate) fn started() {
    IS_STARTED.store(true, Ordering::Release);
}
/// Get the started flag
pub(crate) fn is_started() -> bool {
    IS_STARTED.load(Ordering::Acquire)
}
