//! Metrics related to Chain Follower analytics.

use cardano_blockchain_types::Network;
use cardano_chain_follower::Statistics;

use crate::settings::Settings;

mod reporter;

/// Updates Chain Follower metrics to current values.
pub(crate) fn update() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network();

    let follower_stats = Statistics::new(network);

    report_mithril(&follower_stats, &api_host_names, service_id, network);
    report_live(&follower_stats, &api_host_names, service_id, network);
}

/// Performs reporting Chain Follower's Mithril information to Prometheus.
#[allow(clippy::indexing_slicing)]
fn report_mithril(stats: &Statistics, api_host_names: &str, service_id: &str, network: Network) {
    let stats = &stats.mithril;
    let network = network.to_string();

    reporter::MITHRIL_UPDATES
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.updates).unwrap_or(-1));
    reporter::MITHRIL_TIP
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(u64::from(stats.tip)).unwrap_or(-1));
    reporter::MITHRIL_DL_START
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.dl_start.timestamp());
    reporter::MITHRIL_DL_END
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.dl_end.timestamp());
    reporter::MITHRIL_DL_FAILURES
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.dl_failures).unwrap_or(-1));
    reporter::MITHRIL_LAST_DL_DURATION
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.last_dl_duration).unwrap_or(-1));
    reporter::MITHRIL_DL_SIZE
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.dl_size).unwrap_or(-1));
    reporter::MITHRIL_EXTRACT_START
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.extract_start.timestamp());
    reporter::MITHRIL_EXTRACT_END
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.extract_end.timestamp());
    reporter::MITHRIL_EXTRACT_FAILURES
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.extract_failures).unwrap_or(-1));
    reporter::MITHRIL_EXTRACT_SIZE
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.extract_size).unwrap_or(-1));
    reporter::MITHRIL_DEDUPLICATED_SIZE
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.deduplicated_size).unwrap_or(-1));
    reporter::MITHRIL_DEDUPLICATED
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.deduplicated).unwrap_or(-1));
    reporter::MITHRIL_CHANGED
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.changed).unwrap_or(-1));
    reporter::MITHRIL_NEW
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.new).unwrap_or(-1));
    reporter::MITHRIL_VALIDATE_START
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.validate_start.timestamp());
    reporter::MITHRIL_VALIDATE_END
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.validate_end.timestamp());
    reporter::MITHRIL_VALIDATE_FAILURES
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.validate_failures).unwrap_or(-1));
    reporter::MITHRIL_INVALID_BLOCKS
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.invalid_blocks).unwrap_or(-1));
    reporter::MITHRIL_DOWNLOAD_OR_VALIDATION_FAILED
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.download_or_validation_failed).unwrap_or(-1));
    reporter::MITHRIL_FAILED_TO_GET_TIP
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.failed_to_get_tip).unwrap_or(-1));
    reporter::MITHRIL_TIP_DID_NOT_ADVANCE
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.tip_did_not_advance).unwrap_or(-1));
    reporter::MITHRIL_TIP_FAILED_TO_SEND_TO_UPDATER
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.tip_failed_to_send_to_updater).unwrap_or(-1));
    reporter::MITHRIL_FAILED_TO_ACTIVATE_NEW_SNAPSHOT
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.failed_to_activate_new_snapshot).unwrap_or(-1));
}

/// Performs reporting Chain Follower's Live information to Prometheus.
#[allow(clippy::indexing_slicing)]
fn report_live(stats: &Statistics, api_host_names: &str, service_id: &str, network: Network) {
    let stats = &stats.live;
    let network = network.to_string();

    reporter::LIVE_SYNC_START
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.sync_start.timestamp());
    reporter::LIVE_SYNC_END
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.sync_end.map_or(0, |s| s.timestamp()));
    reporter::LIVE_BACKFILL_START
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.backfill_start.map_or(0, |s| s.timestamp()));
    reporter::LIVE_BACKFILL_SIZE
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.backfill_size).unwrap_or(-1));
    reporter::LIVE_BACKFILL_END
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.backfill_end.map_or(0, |s| s.timestamp()));
    reporter::LIVE_BACKFILL_FAILURES
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.backfill_failures).unwrap_or(-1));
    reporter::LIVE_BACKFILL_FAILURE_TIME
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.backfill_failure_time.map_or(0, |s| s.timestamp()));
    reporter::LIVE_BLOCKS
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.blocks).unwrap_or(-1));
    reporter::LIVE_HEAD_SLOT
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(u64::from(stats.head_slot)).unwrap_or(-1));
    reporter::LIVE_TIP
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(u64::from(stats.tip)).unwrap_or(-1));
    reporter::LIVE_RECONNECTS
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.reconnects).unwrap_or(-1));
    reporter::LIVE_LAST_CONNECT
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.last_connect.timestamp());
    reporter::LIVE_LAST_DISCONNECT
        .with_label_values(&[api_host_names, service_id, &network])
        .set(stats.last_disconnect.timestamp());
    reporter::LIVE_CONNECTED
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::from(stats.connected));
    reporter::LIVE_ROLLBACKS_LIVE_COUNT
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.rollbacks.live.len()).unwrap_or(-1));
    reporter::LIVE_ROLLBACKS_PEER_COUNT
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.rollbacks.peer.len()).unwrap_or(-1));
    reporter::LIVE_ROLLBACKS_FOLLOWER_COUNT
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.rollbacks.follower.len()).unwrap_or(-1));
    reporter::LIVE_NEW_BLOCKS
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.new_blocks).unwrap_or(-1));
    reporter::LIVE_INVALID_BLOCKS
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.invalid_blocks).unwrap_or(-1));
    reporter::LIVE_FOLLOWER_COUNT
        .with_label_values(&[api_host_names, service_id, &network])
        .set(i64::try_from(stats.follower.len()).unwrap_or(-1));
}
