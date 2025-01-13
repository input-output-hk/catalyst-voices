//! Metrics related to memory analytics.

use memory_stats::memory_stats;
use stats_alloc::{Region, Stats, StatsAlloc, INSTRUMENTED_SYSTEM};
use tracing::log::error;

use std::alloc::System;
use std::{
    sync::{Arc, Mutex},
    thread,
    time::Duration,
};

lazy_static::lazy_static! {
  pub(crate) static ref GLOBAL_METRICS: Arc<Mutex<MemoryMetrics>> = Arc::new(Mutex::new(MemoryMetrics::default()));
}

const UPDATE_INTERVAL_MILLI: u64 = 1000;

/// Use the instrumented allocator for gathering allocation statistics.
#[global_allocator]
static GLOBAL: &StatsAlloc<System> = &INSTRUMENTED_SYSTEM;

#[derive(Debug, Default)]
pub(crate) struct MemoryMetrics {
    pub(crate) allocator_stats: Stats,
    pub(crate) physical_usage: Option<usize>,
    pub(crate) virtual_usage: Option<usize>,
}

impl MemoryMetrics {
    fn update(&mut self) {
        let stats = Region::new(&GLOBAL);

        self.allocator_stats = stats.change();

        if let Some(mem_stats) = memory_stats() {
            self.physical_usage = Some(mem_stats.physical_mem);
            self.virtual_usage = Some(mem_stats.virtual_mem);
        } else {
            self.physical_usage = None;
            self.virtual_usage = None;
        }
    }

    pub(crate) fn start_metrics_updater() {
        thread::spawn(move || {
            let interval = Duration::from_millis(UPDATE_INTERVAL_MILLI); // Update every 5 seconds
            loop {
                {
                    match GLOBAL_METRICS.lock() {
                        Ok(mut metrics) => metrics.update(),
                        Err(err) => {
                            error!("Failed to update memory usage metrics: {:?}", err);
                        },
                    }
                }
                thread::sleep(interval);
            }
        });
    }
}
