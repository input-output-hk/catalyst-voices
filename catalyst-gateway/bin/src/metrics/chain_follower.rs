//! Metrics related to Chain Follower analytics.

use std::{
    sync::atomic::{AtomicBool, Ordering},
    thread,
};

use cardano_chain_follower::Statistics;

use crate::settings::Settings;

/// This is to prevent the init function from accidentally being called multiple times.
static IS_INITIALIZED: AtomicBool = AtomicBool::new(false);

/// Starts a background thread to periodically update Chain Follower metrics.
///
/// This function spawns a thread that updates the memory metrics
/// at regular intervals defined by the `METRICS_MEMORY_INTERVAL` envar.
pub(crate) fn init_metrics_reporter() {
    if IS_INITIALIZED.swap(true, Ordering::SeqCst) {
        return;
    }

    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let chain = Settings::cardano_network();

    thread::spawn(move || {
        loop {
            {
                let chain_stats = Statistics::new(chain);
            }

            thread::sleep(Settings::metrics_follower_interval());
        }
    });
}

/// All the related Chain Follower reporting metrics to the Prometheus service are inside
/// this module.
mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_int_gauge_vec, IntGaugeVec};

    /// Labels for the chain follower metrics
    const MEMORY_METRIC_LABELS: [&str; 2] = ["api_host_names", "service_id"];
}
