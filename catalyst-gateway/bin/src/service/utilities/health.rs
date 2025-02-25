//! Utilities used for `health` functionality.

use std::{
    sync::atomic::{AtomicBool, AtomicU64, Ordering},
    time::SystemTime,
};

/// Flag to determine if the service is live.
///
/// Defaults to `true`.
static IS_LIVE: AtomicBool = AtomicBool::new(true);

/// Timestamp in seconds used to determine if the service is live.
static LIVE_COUNTER: AtomicU64 = AtomicU64::new(0);

/// Get the `IS_LIVE` flag.
pub(crate) fn is_live() -> bool {
    IS_LIVE.load(Ordering::Acquire)
}

/// Set the `IS_LIVE` flag to `false`.
pub(crate) fn set_not_live() {
    IS_LIVE.store(false, Ordering::Release);
}

/// Get the `LIVE_COUNTER` timestamp value, in seconds.
pub(crate) fn get_live_counter() -> u64 {
    LIVE_COUNTER.load(Ordering::SeqCst)
}

/// Set the `LIVE_COUNTER` to current timestamp, in seconds.
pub(crate) fn set_live_counter(now: u64) {
    LIVE_COUNTER.store(now, Ordering::SeqCst);
}

/// Returns the timestamp of current system time, in seconds.
pub(crate) fn get_current_timestamp() -> Option<u64> {
    SystemTime::now()
        .duration_since(SystemTime::UNIX_EPOCH)
        .ok()
        .map(|s| s.as_secs())
}
