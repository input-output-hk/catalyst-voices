//! Metrics related to Chain Indexer analytics.

use std::ops::Sub;

use crate::{
    cardano::event::{ChainIndexerEvent as Event, ChainIndexerEventReceiver},
    settings::Settings,
};

/// Spawn an updater backround task, which follows `ChainIndexerEvent` from the provided
/// channel and updates the corresponding metrics
pub(crate) fn run_updater(mut event_channel: ChainIndexerEventReceiver) {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    tokio::spawn(async move {
        while let Some(event) = event_channel.receive_event().await {
            if let Event::SyncLiveChainStarted = event {
                reporter::LIVE_REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(0);
            }
            if let Event::SyncImmutableChainStarted = event {
                reporter::IMMUTABLE_REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(0);
            }
            if let Event::SyncLiveChainCompleted = event {
                reporter::LIVE_REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(1);
            }
            if let Event::SyncImmutableChainCompleted = event {
                reporter::IMMUTABLE_REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(1);
            }
            if let Event::SyncTasksChanged { current_sync_tasks } = event {
                reporter::RUNNING_INDEXER_TASKS_COUNT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(From::from(current_sync_tasks));
            }
            if let Event::LiveTipSlotChanged {
                live_slot,
                immutable_slot,
            } = event
            {
                reporter::CURRENT_LIVE_TIP_SLOT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(u64::from(live_slot)).unwrap_or(-1));
                reporter::SLOT_TIP_DIFF
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(
                        u64::from(live_slot.sub(immutable_slot))
                            .try_into()
                            .unwrap_or(-1),
                    );
            }
            if let Event::ImmutableTipSlotChanged {
                live_slot,
                immutable_slot,
            } = event
            {
                reporter::CURRENT_IMMUTABLE_TIP_SLOT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(u64::from(immutable_slot)).unwrap_or(-1));

                reporter::SLOT_TIP_DIFF
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(
                        u64::from(live_slot.sub(immutable_slot))
                            .try_into()
                            .unwrap_or(-1),
                    );
            }
            if let Event::IndexedSlotProgressed { slot } = event {
                reporter::HIGHEST_COMPLETE_INDEXED_SLOT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(u64::from(slot)).unwrap_or(-1));
            }
            if let Event::BackwardDataPurged = event {
                reporter::TRIGGERED_BACKWARD_PURGES_COUNT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();
            }
            if let Event::ForwardDataPurged { purge_slots } = event {
                reporter::TRIGGERED_FORWARD_PURGES_COUNT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();
                reporter::PURGED_SLOTS
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(purge_slots).unwrap_or(-1));
            }
        }
    });
}

/// All the related Chain Indexer reporting metrics to the Prometheus service are inside
/// this module.
pub(crate) mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_counter_vec, register_int_gauge_vec, CounterVec, IntGaugeVec};

    /// Labels for the metrics.
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// Chain Indexer current live tip slot.
    pub(crate) static CURRENT_LIVE_TIP_SLOT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_current_live_tip_slot",
            "Chain Indexer current live tip slot",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer current immutable tip slot.
    pub(crate) static CURRENT_IMMUTABLE_TIP_SLOT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_current_immutable_tip_slot",
            "Chain Indexer current immutable tip slot",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer highest complete indexed slot.
    pub(crate) static HIGHEST_COMPLETE_INDEXED_SLOT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_highest_complete_indexed_slot",
            "Chain Indexer highest complete indexed slot",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer number of current running indexer tasks.
    pub(crate) static RUNNING_INDEXER_TASKS_COUNT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_running_indexer_tasks_count",
            "Chain Indexer number of current running indexer tasks",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer number of times triggering backward data purge.
    pub(crate) static TRIGGERED_BACKWARD_PURGES_COUNT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "indexer_triggered_backward_purges_count",
            "Chain Indexer number of times triggering backward data purge",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer number of times triggering forward data purge.
    pub(crate) static TRIGGERED_FORWARD_PURGES_COUNT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "indexer_triggered_forward_purges_count",
            "Chain Indexer number of times triggering forward data purge",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer number of purged slots.
    pub(crate) static PURGED_SLOTS: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_triggered_purged_slots",
            "Chain Indexer total number of slots that have already been purged",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer indicator whether immutable tip is reached or in progress.
    pub(crate) static IMMUTABLE_REACHED_TIP: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_reached_immutable_tip_indicator",
            "Chain Indexer indicator whether immutable chain tip is reached or in progress. It also reflects a freshly downloaded mithril snapshots, when new immutable synchronization starts.",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer indicator whether live tip is reached or in progress.
    pub(crate) static LIVE_REACHED_TIP: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_reached_live_tip_indicator",
            "Chain Indexer indicator whether live chain tip is reached or in progress. Live chain synchronization never stops, this metric shows when first tip is reached.",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// The slot difference between immutable tip slot and the volatile tip slot number.
    pub(crate) static SLOT_TIP_DIFF: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_slot_tip_diff",
            "The slot difference between immutable tip slot and the volatile tip slot number",
            &METRIC_LABELS
        )
        .unwrap()
    });
}
