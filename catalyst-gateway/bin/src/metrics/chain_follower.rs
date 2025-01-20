//! Metrics related to Chain Follower analytics.

use std::{
    sync::atomic::{AtomicBool, Ordering},
    thread,
};

use cardano_chain_follower::{Network, Statistics};

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

    let network_idx = match chain {
        Network::Mainnet => 0,
        Network::Preprod => 1,
        Network::Preview => 2,
    };

    thread::spawn(move || {
        loop {
            #[allow(clippy::indexing_slicing)]
            {
                let follower_stats = Statistics::new(chain);

                report_mithril(&follower_stats, &api_host_names, service_id, network_idx);
                report_live();
            }

            thread::sleep(Settings::metrics_follower_interval());
        }
    });
}

/// Performs reporting Chain Follower's Mithril to Prometheus.
#[allow(clippy::indexing_slicing)]
fn report_mithril(stats: &Statistics, api_host_names: &str, service_id: &str, net: usize) {
    let stats = &stats.mithril;

    if !(0..3).contains(&net) {
        return;
    }

    reporter::FOLLOWER_UPDATES[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.updates).unwrap_or(-1));
    reporter::FOLLOWER_TIP[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.tip).unwrap_or(-1));
    reporter::FOLLOWER_DL_START[net]
        .with_label_values(&[api_host_names, service_id])
        .set(stats.dl_start.timestamp());
    reporter::FOLLOWER_DL_END[net]
        .with_label_values(&[api_host_names, service_id])
        .set(stats.dl_end.timestamp());
    reporter::FOLLOWER_DL_FAILURES[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.dl_failures).unwrap_or(-1));
    reporter::FOLLOWER_LAST_DL_DURATION[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.last_dl_duration).unwrap_or(-1));
    reporter::FOLLOWER_DL_SIZE[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.dl_size).unwrap_or(-1));
    reporter::FOLLOWER_EXTRACT_START[net]
        .with_label_values(&[api_host_names, service_id])
        .set(stats.extract_start.timestamp());
    reporter::FOLLOWER_EXTRACT_END[net]
        .with_label_values(&[api_host_names, service_id])
        .set(stats.extract_end.timestamp());
    reporter::FOLLOWER_EXTRACT_FAILURES[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.extract_failures).unwrap_or(-1));
    reporter::FOLLOWER_EXTRACT_SIZE[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.extract_size).unwrap_or(-1));
    reporter::FOLLOWER_DEDUPLICATED_SIZE[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.deduplicated_size).unwrap_or(-1));
    reporter::FOLLOWER_DEDUPLICATED[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.deduplicated).unwrap_or(-1));
    reporter::FOLLOWER_CHANGED[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.changed).unwrap_or(-1));
    reporter::FOLLOWER_NEW[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.new).unwrap_or(-1));
    reporter::FOLLOWER_VALIDATE_START[net]
        .with_label_values(&[api_host_names, service_id])
        .set(stats.validate_start.timestamp());
    reporter::FOLLOWER_VALIDATE_END[net]
        .with_label_values(&[api_host_names, service_id])
        .set(stats.validate_end.timestamp());
    reporter::FOLLOWER_VALIDATE_FAILURES[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.validate_failures).unwrap_or(-1));
    reporter::FOLLOWER_INVALID_BLOCKS[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.invalid_blocks).unwrap_or(-1));
    reporter::FOLLOWER_DOWNLOAD_OR_VALIDATION_FAILED[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.download_or_validation_failed).unwrap_or(-1));
    reporter::FOLLOWER_FAILED_TO_GET_TIP[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.failed_to_get_tip).unwrap_or(-1));
    reporter::FOLLOWER_TIP_DID_NOT_ADVANCE[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.tip_did_not_advance).unwrap_or(-1));
    reporter::FOLLOWER_TIP_FAILED_TO_SEND_TO_UPDATER[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.tip_failed_to_send_to_updater).unwrap_or(-1));
    reporter::FOLLOWER_FAILED_TO_ACTIVATE_NEW_SNAPSHOT[net]
        .with_label_values(&[api_host_names, service_id])
        .set(i64::try_from(stats.failed_to_activate_new_snapshot).unwrap_or(-1));
}

/// Performs reporting Chain Follower's Mithril to Prometheus.
#[allow(clippy::indexing_slicing)]
fn report_live() {}

/// All the related Chain Follower reporting metrics to the Prometheus service are inside
/// this module.
mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_int_gauge_vec, IntGaugeVec};

    /// Chain networks use as the metrics namespace.
    const FOLLOWER_METRIC_NETWORKS: [&str; 3] = ["mainnet", "preprod", "preview"];

    /// Labels for the chain follower metrics
    const FOLLOWER_METRIC_LABELS: [&str; 2] = ["api_host_names", "service_id"];

    /// Number of Mithril Snapshots that have downloaded successfully.
    pub(super) static FOLLOWER_UPDATES: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_mithril_updates"),
                "Number of Mithril Snapshots that have downloaded successfully",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Immutable TIP Slot# - Origin = No downloaded snapshot.
    pub(super) static FOLLOWER_TIP: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_mithril_tip"),
                "Immutable TIP Slot#",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Time we started downloading the current snapshot.
    pub(super) static FOLLOWER_DL_START: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_dl_start"),
                "Time we started downloading the current snapshot (UNIX timestamp)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Time we finished downloading the current snapshot.
    pub(super) static FOLLOWER_DL_END: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_dl_end"),
                "Time we finished downloading the current snapshot (UNIX timestamp)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Number of times download failed.
    pub(super) static FOLLOWER_DL_FAILURES: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_mithril_dl_failures"),
                "Number of times download failed",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Time the last download took.
    pub(super) static FOLLOWER_LAST_DL_DURATION: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_last_dl_duration"),
                "Time the last download took (seconds)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Size of the download archive.
    pub(super) static FOLLOWER_DL_SIZE: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_mithril_dl_size"),
                "Size of the download archive (bytes)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Number of times extraction failed.
    pub(super) static FOLLOWER_EXTRACT_FAILURES: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_mithril_extract_failures"),
                "Number of times extraction failed",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Extraction start time.
    pub(super) static FOLLOWER_EXTRACT_START: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_extract_start"),
                "Extraction start time (UNIX timestamp)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Extraction end time.
    pub(super) static FOLLOWER_EXTRACT_END: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_extract_end"),
                "Extraction end time (UNIX timestamp)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Size of last extracted snapshot.
    pub(super) static FOLLOWER_EXTRACT_SIZE: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_extract_size"),
                "Size of last extracted snapshot (bytes)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Deduplicated Size vs previous snapshot.
    pub(super) static FOLLOWER_DEDUPLICATED_SIZE: LazyLock<[IntGaugeVec; 3]> =
        LazyLock::new(|| {
            FOLLOWER_METRIC_NETWORKS.map(|network| {
                register_int_gauge_vec!(
                    format!("{network}_follower_deduplicated_size"),
                    "Deduplicated Size vs previous snapshot",
                    &FOLLOWER_METRIC_LABELS
                )
                .unwrap()
            })
        });

    /// Number of identical files deduplicated from previous snapshot.
    pub(super) static FOLLOWER_DEDUPLICATED: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_deduplicated"),
                "Number of identical files deduplicated from previous snapshot",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Number of changed files from previous snapshot.
    pub(super) static FOLLOWER_CHANGED: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_changed"),
                "Number of changed files from previous snapshot",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Number of new files from previous snapshot.
    pub(super) static FOLLOWER_NEW: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_new"),
                "Number of new files from previous snapshot",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Mithril Certificate Validation Start Time.
    pub(super) static FOLLOWER_VALIDATE_START: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_validate_start"),
                "Mithril Certificate Validation Start Time (UNIX timestamp)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Mithril Certificate Validation End Time.
    pub(super) static FOLLOWER_VALIDATE_END: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_validate_end"),
                "Mithril Certificate Validation End Time (UNIX timestamp)",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Number of times validation failed (bad snapshot).
    pub(super) static FOLLOWER_VALIDATE_FAILURES: LazyLock<[IntGaugeVec; 3]> =
        LazyLock::new(|| {
            FOLLOWER_METRIC_NETWORKS.map(|network| {
                register_int_gauge_vec!(
                    format!("{network}_follower_validate_failures"),
                    "Number of times validation failed (bad snapshot)",
                    &FOLLOWER_METRIC_LABELS
                )
                .unwrap()
            })
        });

    /// Blocks that failed to deserialize from the Mithril immutable chain.
    pub(super) static FOLLOWER_INVALID_BLOCKS: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_invalid_blocks"),
                "Blocks that failed to deserialize from the Mithril immutable chain",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

    /// Download or Validation Failed.
    pub(super) static FOLLOWER_DOWNLOAD_OR_VALIDATION_FAILED: LazyLock<[IntGaugeVec; 3]> =
        LazyLock::new(|| {
            FOLLOWER_METRIC_NETWORKS.map(|network| {
                register_int_gauge_vec!(
                    format!("{network}_follower_download_or_validation_failed"),
                    "Download or Validation Failed",
                    &FOLLOWER_METRIC_LABELS
                )
                .unwrap()
            })
        });

    /// Failed to get tip from Mithril snapshot.
    pub(super) static FOLLOWER_FAILED_TO_GET_TIP: LazyLock<[IntGaugeVec; 3]> =
        LazyLock::new(|| {
            FOLLOWER_METRIC_NETWORKS.map(|network| {
                register_int_gauge_vec!(
                    format!("{network}_follower_failed_to_get_tip"),
                    "Failed to get tip from Mithril snapshot",
                    &FOLLOWER_METRIC_LABELS
                )
                .unwrap()
            })
        });

    /// Tip failed to advance.
    pub(super) static FOLLOWER_TIP_DID_NOT_ADVANCE: LazyLock<[IntGaugeVec; 3]> =
        LazyLock::new(|| {
            FOLLOWER_METRIC_NETWORKS.map(|network| {
                register_int_gauge_vec!(
                    format!("{network}_follower_tip_did_not_advance"),
                    "Tip failed to advance",
                    &FOLLOWER_METRIC_LABELS
                )
                .unwrap()
            })
        });

    /// Failed to send new tip to updater.
    pub(super) static FOLLOWER_TIP_FAILED_TO_SEND_TO_UPDATER: LazyLock<[IntGaugeVec; 3]> =
        LazyLock::new(|| {
            FOLLOWER_METRIC_NETWORKS.map(|network| {
                register_int_gauge_vec!(
                    format!("{network}_follower_tip_failed_to_send_to_updater"),
                    "Failed to send new tip to updater",
                    &FOLLOWER_METRIC_LABELS
                )
                .unwrap()
            })
        });

    /// Failed to activate new snapshot.
    pub(super) static FOLLOWER_FAILED_TO_ACTIVATE_NEW_SNAPSHOT: LazyLock<[IntGaugeVec; 3]> =
        LazyLock::new(|| {
            FOLLOWER_METRIC_NETWORKS.map(|network| {
                register_int_gauge_vec!(
                    format!("{network}_follower_failed_to_activate_new_snapshot"),
                    "Failed to activate new snapshot",
                    &FOLLOWER_METRIC_LABELS
                )
                .unwrap()
            })
        });
}
