//! Utilities used for system `Readiness` functionality.

use std::sync::atomic::{
    AtomicBool,
    Ordering::{Acquire, Release},
};

/// Flag to determine if the Index DB background task running or not
static INDEX_DB_PROBE_RUNNING: AtomicBool = AtomicBool::new(false);

/// Get the `INDEX_DB_PROBE_RUNNING` flag.
pub(crate) fn index_db_probe_is_running() -> bool {
    INDEX_DB_PROBE_RUNNING.load(Acquire)
}

/// Set the `INDEX_DB_PROBE_RUNNING` flag to `true`.
pub(crate) fn index_db_probe_start() {
    INDEX_DB_PROBE_RUNNING.store(true, Release);
}

/// Set the `INDEX_DB_PROBE_RUNNING` flag to `false`.
pub(crate) fn index_db_probe_stop() {
    INDEX_DB_PROBE_RUNNING.store(false, Release);
}
