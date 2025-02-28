//! Utilities used for `Liveness` functionality.

use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};

/// Flag to determine if the service is live.
///
/// Defaults to `true`.
static IS_LIVE: AtomicBool = AtomicBool::new(true);

/// Timestamp in seconds used to determine if the service is live.
static LIVE_PANIC_COUNTER: AtomicU64 = AtomicU64::new(0);

/// Get the `IS_LIVE` flag.
pub(crate) fn is_live() -> bool {
    IS_LIVE.load(Ordering::Acquire)
}

/// Set the `IS_LIVE` flag to `false`.
pub(crate) fn set_not_live() {
    IS_LIVE.store(false, Ordering::Release);
}

/// Get the `LIVE_PANIC_COUNTER` value.
pub(crate) fn get_live_counter() -> u64 {
    LIVE_PANIC_COUNTER.load(Ordering::SeqCst)
}

/// Increase `LIVE_PANIC_COUNTER` by one.
pub(crate) fn inc_live_counter() {
    LIVE_PANIC_COUNTER.fetch_add(1, Ordering::SeqCst);
}

/// Reset the `LIVE_PANIC_COUNTER` to zero, returns last count.
pub(crate) fn live_counter_reset() -> u64 {
    LIVE_PANIC_COUNTER.swap(0, Ordering::SeqCst)
}
