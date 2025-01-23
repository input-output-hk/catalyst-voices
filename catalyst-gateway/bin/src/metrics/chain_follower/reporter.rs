//! All the related Chain Follower reporting metrics to the Prometheus service are inside
//! this module.

use std::sync::LazyLock;

use prometheus::{register_int_gauge_vec, IntGaugeVec};

// TODO: directly map those network labels from `Network` variants instead
/// Chain networks use as the metrics namespace.
const FOLLOWER_METRIC_NETWORKS: [&str; 3] = ["mainnet", "preprod", "preview"];

/// Labels for the chain follower metrics
const FOLLOWER_METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

// -- Mithril

/// Number of Mithril Snapshots that have downloaded successfully.
pub(super) static MITHRIL_UPDATES: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
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
pub(super) static MITHRIL_TIP: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
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
pub(super) static MITHRIL_DL_START: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_dl_start"),
            "Time we started downloading the current snapshot (UNIX timestamp)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Time we finished downloading the current snapshot.
pub(super) static MITHRIL_DL_END: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_dl_end"),
            "Time we finished downloading the current snapshot (UNIX timestamp)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Number of times download failed.
pub(super) static MITHRIL_DL_FAILURES: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
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
pub(super) static MITHRIL_LAST_DL_DURATION: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_last_dl_duration"),
            "Time the last download took (seconds)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Size of the download archive.
pub(super) static MITHRIL_DL_SIZE: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
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
pub(super) static MITHRIL_EXTRACT_FAILURES: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
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
pub(super) static MITHRIL_EXTRACT_START: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_extract_start"),
            "Extraction start time (UNIX timestamp)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Extraction end time.
pub(super) static MITHRIL_EXTRACT_END: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_extract_end"),
            "Extraction end time (UNIX timestamp)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Size of last extracted snapshot.
pub(super) static MITHRIL_EXTRACT_SIZE: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_extract_size"),
            "Size of last extracted snapshot (bytes)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Deduplicated Size vs previous snapshot.
pub(super) static MITHRIL_DEDUPLICATED_SIZE: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_deduplicated_size"),
            "Deduplicated Size vs previous snapshot",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Number of identical files deduplicated from previous snapshot.
pub(super) static MITHRIL_DEDUPLICATED: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_deduplicated"),
            "Number of identical files deduplicated from previous snapshot",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Number of changed files from previous snapshot.
pub(super) static MITHRIL_CHANGED: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_changed"),
            "Number of changed files from previous snapshot",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Number of new files from previous snapshot.
pub(super) static MITHRIL_NEW: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_new"),
            "Number of new files from previous snapshot",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Mithril Certificate Validation Start Time.
pub(super) static MITHRIL_VALIDATE_START: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_validate_start"),
            "Mithril Certificate Validation Start Time (UNIX timestamp)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Mithril Certificate Validation End Time.
pub(super) static MITHRIL_VALIDATE_END: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_validate_end"),
            "Mithril Certificate Validation End Time (UNIX timestamp)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Number of times validation failed (bad snapshot).
pub(super) static MITHRIL_VALIDATE_FAILURES: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_validate_failures"),
            "Number of times validation failed (bad snapshot)",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Blocks that failed to deserialize from the Mithril immutable chain.
pub(super) static MITHRIL_INVALID_BLOCKS: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_invalid_blocks"),
            "Blocks that failed to deserialize from the Mithril immutable chain",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Download or Validation Failed.
pub(super) static MITHRIL_DOWNLOAD_OR_VALIDATION_FAILED: LazyLock<[IntGaugeVec; 3]> =
    LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_mithril_download_or_validation_failed"),
                "Download or Validation Failed",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

/// Failed to get tip from Mithril snapshot.
pub(super) static MITHRIL_FAILED_TO_GET_TIP: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_failed_to_get_tip"),
            "Failed to get tip from Mithril snapshot",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Tip failed to advance.
pub(super) static MITHRIL_TIP_DID_NOT_ADVANCE: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_mithril_tip_did_not_advance"),
            "Tip failed to advance",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Failed to send new tip to updater.
pub(super) static MITHRIL_TIP_FAILED_TO_SEND_TO_UPDATER: LazyLock<[IntGaugeVec; 3]> =
    LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_mithril_tip_failed_to_send_to_updater"),
                "Failed to send new tip to updater",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

/// Failed to activate new snapshot.
pub(super) static MITHRIL_FAILED_TO_ACTIVATE_NEW_SNAPSHOT: LazyLock<[IntGaugeVec; 3]> =
    LazyLock::new(|| {
        FOLLOWER_METRIC_NETWORKS.map(|network| {
            register_int_gauge_vec!(
                format!("{network}_follower_mithril_failed_to_activate_new_snapshot"),
                "Failed to activate new snapshot",
                &FOLLOWER_METRIC_LABELS
            )
            .unwrap()
        })
    });

// -- Live

/// The Time that synchronization to this blockchain started
pub(super) static LIVE_SYNC_START: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_sync_start"),
            "The Time that synchronization to this blockchain started",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// The Time that synchronization to this blockchain was complete up-to-tip. None =
/// Not yet synchronized.
pub(super) static LIVE_SYNC_END: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_sync_end"),
            "The Time that synchronization to this blockchain was complete up-to-tip",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// When backfill started
pub(super) static LIVE_BACKFILL_START: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_backfill_start"),
            "When backfill started",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Backfill size to achieve synchronization. (0 before sync completed)
pub(super) static LIVE_BACKFILL_SIZE: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_backfill_size"),
            "Backfill size to achieve synchronization",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// When backfill ended
pub(super) static LIVE_BACKFILL_END: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_backfill_end"),
            "When backfill ended",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Backfill Failures
pub(super) static LIVE_BACKFILL_FAILURES: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_backfill_failures"),
            "Backfill Failures",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// The time of the last backfill failure
pub(super) static LIVE_BACKFILL_FAILURE_TIME: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_backfill_failure_time"),
            "The time of the last backfill failure",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Current Number of Live Blocks
pub(super) static LIVE_BLOCKS: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_blocks"),
            "Current Number of Live Blocks",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// The current head of the live chain slot#
pub(super) static LIVE_HEAD_SLOT: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_head_slot"),
            "The current head of the live chain slot#",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// The current live tip slot# as reported by the peer.
pub(super) static LIVE_TIP: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_tip"),
            "The current live tip slot# as reported by the peer",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Number of times we connected/re-connected to the Node.
pub(super) static LIVE_RECONNECTS: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_reconnects"),
            "Number of times we connected/re-connected to the Node",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Last reconnect time
pub(super) static LIVE_LAST_CONNECT: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_last_connect"),
            "Last reconnect time",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Last disconnect time
pub(super) static LIVE_LAST_DISCONNECT: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_last_disconnect"),
            "Last disconnect time",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Is there an active connection to the node
pub(super) static LIVE_CONNECTED: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_connected"),
            "Is there an active connection to the node",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Rollbacks we did on our live-chain in memory.
pub(super) static LIVE_ROLLBACKS_LIVE_COUNT: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_rollbacks_live_count"),
            "Number of live chain rollback",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Rollbacks reported by the Peer Node.
pub(super) static LIVE_ROLLBACKS_PEER_COUNT: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_rollbacks_peer_count"),
            "Number of rollbacks reported by the peer node",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Rollbacks synthesized for followers.
pub(super) static LIVE_ROLLBACKS_FOLLOWER_COUNT: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_rollbacks_follower_count"),
            "Number of rollbacks synthesized for followers",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// New blocks read from blockchain.
pub(super) static LIVE_NEW_BLOCKS: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_new_blocks"),
            "New blocks read from blockchain",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Blocks that failed to deserialize from the blockchain.
pub(super) static LIVE_INVALID_BLOCKS: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_invalid_blocks"),
            "Blocks that failed to deserialize from the blockchain",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});

/// Number of active Followers
pub(super) static LIVE_FOLLOWER_COUNT: LazyLock<[IntGaugeVec; 3]> = LazyLock::new(|| {
    FOLLOWER_METRIC_NETWORKS.map(|network| {
        register_int_gauge_vec!(
            format!("{network}_follower_live_follower_count"),
            "Number of active Followers",
            &FOLLOWER_METRIC_LABELS
        )
        .unwrap()
    })
});
