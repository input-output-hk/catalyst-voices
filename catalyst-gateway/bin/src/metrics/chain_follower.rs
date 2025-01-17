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
/// This function spawns a thread that updates the Chain Follower metrics
/// at regular intervals defined by `METRICS_FOLLOWER_INTERVAL`.
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
                let follower_stats = Statistics::new(chain);

                // mithril part
                let is_downloading =
                    follower_stats.mithril.dl_end < follower_stats.mithril.dl_start;
                let is_extracting =
                    follower_stats.mithril.extract_end < follower_stats.mithril.extract_start;
                let is_validating =
                    follower_stats.mithril.validate_end < follower_stats.mithril.validate_start;

                if is_downloading {
                    reporter::FOLLOWER_DL_FAILURES
                        .with_label_values(&[&api_host_names, service_id])
                        .set(i64::try_from(follower_stats.mithril.dl_failures).unwrap_or(-1));
                    reporter::FOLLOWER_DL_SIZE
                        .with_label_values(&[&api_host_names, service_id])
                        .set(i64::try_from(follower_stats.mithril.dl_size).unwrap_or(-1));
                }
                if is_extracting {
                    reporter::FOLLOWER_EXTRACT_FAILURES
                        .with_label_values(&[&api_host_names, service_id])
                        .set(i64::try_from(follower_stats.mithril.extract_failures).unwrap_or(-1));
                    reporter::FOLLOWER_EXTRACT_SIZE
                        .with_label_values(&[&api_host_names, service_id])
                        .set(i64::try_from(follower_stats.mithril.extract_size).unwrap_or(-1));
                }
                if is_validating {}

                // live part
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
    const FOLLOWER_METRIC_LABELS: [&str; 2] = ["api_host_names", "service_id"];

    /// The number of times download failed.
    pub(super) static FOLLOWER_DL_FAILURES: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "follower_dl_failures",
            "Number of times download failed",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    });

    /// The size of the download archive, in bytes.
    pub(super) static FOLLOWER_DL_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "follower_dl_size",
            "Size of the download archive",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    });

    /// The number of times extraction failed.
    pub(super) static FOLLOWER_EXTRACT_FAILURES: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "follower_extract_failures",
            "Number of times extraction failed",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    });

    /// The size of last extracted snapshot.
    pub(super) static FOLLOWER_EXTRACT_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "follower_extract_size",
            "Size of last extracted snapshot",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    });
}
