//! Metrics related to Chain Indexer analytics.

/// All the related Chain Indexer metrics update functions
pub(crate) mod metrics_updater {
    use std::ops::Sub;

    use cardano_chain_follower::Slot;

    use crate::{metrics::chain_indexer::reporter, settings::Settings};

    /// Triggers to indicate that the Chain Indexer is starting or reaches the live tip.
    pub(crate) fn reached_live_tip(reached: bool) {
        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = Settings::cardano_network().to_string();

        reporter::LIVE_REACHED_TIP
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::from(reached));
    }

    /// Triggers to indicate that the Chain Indexer is starting or reaches the immutable
    /// tip.
    pub(crate) fn reached_immutable_tip(reached: bool) {
        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = Settings::cardano_network().to_string();

        reporter::IMMUTABLE_REACHED_TIP
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::from(reached));
    }

    /// Triggers to update the number of current synchronization tasks.
    pub(crate) fn sync_tasks(current_sync_tasks: u16) {
        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = Settings::cardano_network().to_string();

        reporter::RUNNING_INDEXER_TASKS_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(From::from(current_sync_tasks));
    }

    /// Triggers to update the tip for both live and immutable slots.
    pub(crate) fn current_tip_slot(
        live_slot: Slot,
        immutable_slot: Slot,
    ) {
        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = Settings::cardano_network().to_string();

        reporter::CURRENT_LIVE_TIP_SLOT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(u64::from(live_slot)).unwrap_or(-1));
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

    /// Triggers to update the highest indexed slot progress.
    pub(crate) fn highest_complete_indexed_slot(slot: Slot) {
        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = Settings::cardano_network().to_string();

        reporter::HIGHEST_COMPLETE_INDEXED_SLOT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(u64::from(slot)).unwrap_or(-1));
    }

    /// Triggers to update when backward data is purged.
    pub(crate) fn backward_data_purge() {
        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = Settings::cardano_network().to_string();

        reporter::TRIGGERED_BACKWARD_PURGES_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .inc();
    }

    /// Triggers to update when forward data is purged.
    pub(crate) fn forward_data_purge(purge_slots: u64) {
        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = Settings::cardano_network().to_string();

        reporter::TRIGGERED_FORWARD_PURGES_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .inc();
        reporter::PURGED_SLOTS
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(purge_slots).unwrap_or(-1));
    }
}

/// All the related Chain Indexer reporting metrics to the Prometheus service are inside
/// this module.
pub(crate) mod reporter {
    use std::sync::LazyLock;

    use prometheus::{
        register_int_counter_vec, register_int_gauge_vec, IntCounterVec, IntGaugeVec,
    };

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
    pub(crate) static TRIGGERED_BACKWARD_PURGES_COUNT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "indexer_triggered_backward_purges_count",
                "Chain Indexer number of times triggering backward data purge",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Chain Indexer number of times triggering forward data purge.
    pub(crate) static TRIGGERED_FORWARD_PURGES_COUNT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
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
