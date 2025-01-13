//! Metrics related to memory analytics.

use std::{
    alloc::System,
    sync::{Arc, Mutex},
    thread,
    time::Duration,
};

use memory_stats::memory_stats;
use stats_alloc::{Region, Stats, StatsAlloc, INSTRUMENTED_SYSTEM};
use tracing::log::error;

lazy_static::lazy_static! {
  /// A global, thread-safe container for memory metrics.
  static ref GLOBAL_METRICS: Arc<Mutex<MemoryMetrics>> = Arc::new(Mutex::new(MemoryMetrics::default()));
}

/// Interval for updating memory metrics, in milliseconds.
const UPDATE_INTERVAL_MILLI: u64 = 1000;

/// Use the instrumented allocator for gathering allocation statistics.
#[global_allocator]
static GLOBAL: &StatsAlloc<System> = &INSTRUMENTED_SYSTEM;

/// A structure for storing memory metrics, including allocator statistics
/// and physical/virtual memory usage.
#[derive(Debug, Default, Clone)]
pub(crate) struct MemoryMetrics {
    /// Statistics from the global allocator, including allocations and deallocations from
    /// `stats_alloc::Stats`.
    pub(crate) allocator_stats: Stats,
    /// Physical memory usage of the application, if available.
    pub(crate) physical_usage: Option<usize>,
    /// Virtual memory usage of the application, if available.
    pub(crate) virtual_usage: Option<usize>,
}

impl MemoryMetrics {
    /// Updates the memory metrics with the latest allocator statistics and memory stats.
    ///
    /// # Arguments
    /// * `allocator_stats` - Current statistics from the global allocator.
    fn update(&mut self, allocator_stats: Stats) {
        self.allocator_stats = allocator_stats;

        if let Some(mem_stats) = memory_stats() {
            self.physical_usage = Some(mem_stats.physical_mem);
            self.virtual_usage = Some(mem_stats.virtual_mem);
        } else {
            self.physical_usage = None;
            self.virtual_usage = None;
        }
    }

    /// Retrieves a clone of the current memory metrics.
    ///
    /// # Returns
    /// * A clone of the `MemoryMetrics` structure containing the latest metrics.
    pub(crate) fn retrieve_metrics() -> Self {
        let metrics = GLOBAL_METRICS.lock().unwrap();
        metrics.clone()
    }

    /// Starts a background thread to periodically update memory metrics.
    ///
    /// This function spawns a thread that updates the global `MemoryMetrics`
    /// structure at regular intervals defined by `UPDATE_INTERVAL_MILLI`.
    pub(crate) fn start_metrics_updater() {
        let stats = Region::new(GLOBAL);

        thread::spawn(move || {
            let interval = Duration::from_millis(UPDATE_INTERVAL_MILLI);
            loop {
                let allocator_stats = stats.change();
                match GLOBAL_METRICS.lock() {
                    Ok(mut metrics) => metrics.update(allocator_stats),
                    Err(err) => {
                        error!("Failed to update memory usage metrics: {:?}", err);
                    },
                }
                thread::sleep(interval);
            }
        });
    }
}
