//! Metrics related to memory analytics.

use std::{
    alloc::System,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, LazyLock, RwLock,
    },
    thread,
};

use memory_stats::memory_stats;
use stats_alloc::{Region, Stats, StatsAlloc, INSTRUMENTED_SYSTEM};
use tracing::log::error;

use crate::settings::Settings;

/// Use the instrumented allocator for gathering allocation statistics.
/// Note: This wraps the global allocator.
/// All structs that use the global allocator can be tracked.
#[global_allocator]
static GLOBAL: &StatsAlloc<System> = &INSTRUMENTED_SYSTEM;

/// A global, thread-safe container for memory metrics.
static GLOBAL_METRICS: LazyLock<Arc<RwLock<MemoryMetrics>>> =
    LazyLock::new(|| Arc::new(RwLock::new(MemoryMetrics::default())));

/// This is to prevent the init function from accidentally being called multiple times.
static IS_INITIALIZED: AtomicBool = AtomicBool::new(false);

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

    /// Starts a background thread to periodically update memory metrics.
    ///
    /// This function spawns a thread that updates the global `MemoryMetrics`
    /// structure at regular intervals defined by `UPDATE_INTERVAL_MILLI`.
    pub(crate) fn init_metrics_updater() {
        if IS_INITIALIZED.swap(true, Ordering::SeqCst) {
            return;
        }

        let stats = Region::new(GLOBAL);

        thread::spawn(move || {
            loop {
                let allocator_stats = stats.change();
                match GLOBAL_METRICS.read() {
                    Ok(_) => {
                        match GLOBAL_METRICS.write() {
                            Ok(mut writable_metrics) => {
                                writable_metrics.update(allocator_stats);
                            },
                            Err(err) => {
                                error!("Failed to acquire write lock on metrics: {:?}", err);
                            },
                        }
                    },
                    Err(err) => {
                        error!("Failed to read memory usage metrics: {:?}", err);
                    },
                }
                thread::sleep(Settings::metrics_memory_interval());
            }
        });
    }
}
