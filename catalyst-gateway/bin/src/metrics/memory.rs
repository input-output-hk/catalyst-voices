//! Metrics related to memory analytics.

use std::{
    alloc::System,
    sync::atomic::{AtomicBool, Ordering},
    thread,
};

use memory_stats::{memory_stats, MemoryStats};
use stats_alloc::{Region, StatsAlloc, INSTRUMENTED_SYSTEM};

use crate::settings::Settings;

/// Use the instrumented allocator for gathering allocation statistics.
/// Note: This wraps the global allocator.
/// All structs that use the global allocator can be tracked.
#[global_allocator]
static GLOBAL: &StatsAlloc<System> = &INSTRUMENTED_SYSTEM;

/// This is to prevent the init function from accidentally being called multiple times.
static IS_INITIALIZED: AtomicBool = AtomicBool::new(false);

/// Starts a background thread to periodically update memory metrics.
///
/// This function spawns a thread that updates the memory metrics
/// at regular intervals defined by the `METRICS_MEMORY_INTERVAL` envar.
pub(crate) fn init_metrics_updater() {
    if IS_INITIALIZED.swap(true, Ordering::SeqCst) {
        return;
    }

    let stats = Region::new(GLOBAL);
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();

    thread::spawn(move || {
        loop {
            {
                let allocator_stats = stats.change();
                let mem_stats = memory_stats().unwrap_or({
                    MemoryStats {
                        physical_mem: 0,
                        virtual_mem: 0,
                    }
                });

                reporter::MEMORY_PHYSICAL_USAGE
                    .with_label_values(&[&api_host_names, service_id])
                    .set(i64::try_from(mem_stats.physical_mem).unwrap_or(-1));
                reporter::MEMORY_VIRTUAL_USAGE
                    .with_label_values(&[&api_host_names, service_id])
                    .set(i64::try_from(mem_stats.virtual_mem).unwrap_or(-1));
                reporter::MEMORY_ALLOCATION_COUNT
                    .with_label_values(&[&api_host_names, service_id])
                    .set(i64::try_from(allocator_stats.allocations).unwrap_or(-1));
                reporter::MEMORY_DEALLOCATION_COUNT
                    .with_label_values(&[&api_host_names, service_id])
                    .set(i64::try_from(allocator_stats.deallocations).unwrap_or(-1));
                reporter::MEMORY_REALLOCATION_COUNT
                    .with_label_values(&[&api_host_names, service_id])
                    .set(i64::try_from(allocator_stats.reallocations).unwrap_or(-1));
                reporter::MEMORY_BYTES_ALLOCATED
                    .with_label_values(&[&api_host_names, service_id])
                    .set(i64::try_from(allocator_stats.bytes_allocated).unwrap_or(-1));
                reporter::MEMORY_BYTES_DEALLOCATED
                    .with_label_values(&[&api_host_names, service_id])
                    .set(i64::try_from(allocator_stats.bytes_deallocated).unwrap_or(-1));
                reporter::MEMORY_BYTES_REALLOCATED
                    .with_label_values(&[&api_host_names, service_id])
                    .set(i64::try_from(allocator_stats.bytes_reallocated).unwrap_or(-1));
            }

            thread::sleep(Settings::metrics_memory_interval());
        }
    });
}

/// All the related memory reporting metrics to the Prometheus service are inside this
/// module.
mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_int_gauge_vec, IntGaugeVec};

    /// Labels for the memory metrics
    const MEMORY_METRIC_LABELS: [&str; 2] = ["api_host_names", "service_id"];

    /// The "physical" memory used by this process, in bytes.
    pub(super) static MEMORY_PHYSICAL_USAGE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "memory_physical_usage",
            "Amount of physical memory usage in bytes",
            &MEMORY_METRIC_LABELS
        )
        .unwrap()
    });

    /// The "virtual" memory used by this process, in bytes.
    pub(super) static MEMORY_VIRTUAL_USAGE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "memory_virtual_usage",
            "Amount of physical virtual usage in bytes",
            &MEMORY_METRIC_LABELS
        )
        .unwrap()
    });

    /// The number of allocation count in the heap.
    pub(super) static MEMORY_ALLOCATION_COUNT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "memory_allocation_count",
            "Number of allocation count in the heap",
            &MEMORY_METRIC_LABELS
        )
        .unwrap()
    });

    /// The number of deallocation count in the heap.
    pub(super) static MEMORY_DEALLOCATION_COUNT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "memory_deallocation_count",
            "Number of deallocation count in the heap",
            &MEMORY_METRIC_LABELS
        )
        .unwrap()
    });

    /// The number of reallocation count in the heap.
    pub(super) static MEMORY_REALLOCATION_COUNT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "memory_reallocation_count",
            "Number of reallocation count in the heap",
            &MEMORY_METRIC_LABELS
        )
        .unwrap()
    });

    /// The amount of accumulative allocated bytes in the heap.
    pub(super) static MEMORY_BYTES_ALLOCATED: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "memory_bytes_allocated",
            "Amount of accumulative allocated bytes in the heap",
            &MEMORY_METRIC_LABELS
        )
        .unwrap()
    });

    /// The amount of accumulative deallocated bytes in the heap.
    pub(super) static MEMORY_BYTES_DEALLOCATED: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "memory_bytes_deallocated",
            "Amount of accumulative deallocated bytes in the heap",
            &MEMORY_METRIC_LABELS
        )
        .unwrap()
    });

    /// The amount of accumulative reallocated bytes in the heap.
    pub(super) static MEMORY_BYTES_REALLOCATED: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "memory_bytes_reallocated",
            "Amount of accumulative reallocated bytes in the heap",
            &MEMORY_METRIC_LABELS
        )
        .unwrap()
    });
}
