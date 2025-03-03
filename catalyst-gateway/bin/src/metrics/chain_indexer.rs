//! Metrics related to Chain Indexer analytics.

/// All the related Chain Indexer reporting metrics to the Prometheus service are inside
/// this module.
pub(crate) mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_int_gauge_vec, IntGaugeVec};

    /// Labels for the metrics.
    const METRIC_LABELS: [&str; 0] = [];

    /// Chain Indexer current live tip slot#.
    pub(crate) static CURRENT_LIVE_TIP_SLOT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_current_live_tip_slot",
            "Chain Indexer current live tip slot#",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer current immutable tip slot#.
    pub(crate) static CURRENT_IMMUTABLE_TIP_SLOT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_current_immutable_tip_slot",
            "Chain Indexer current immutable tip slot#",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer highest complete indexed slot#.
    pub(crate) static HIGHEST_COMPLETE_INDEXED_SLOT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_highest_complete_indexed_slot",
            "Chain Indexer highest complete indexed slot#",
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

    /// Chain Indexer number of times triggering data purge.
    pub(crate) static TRIGGERED_DATA_PURGES_COUNT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_triggered_data_purges_count",
            "Chain Indexer number of times triggering data purge",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Chain Indexer indicator whether tip is reached or in progress.
    pub(crate) static REACHED_TIP: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "indexer_reached_tip_indicator",
            "Chain Indexer indicator whether tip is reached or in progress",
            &METRIC_LABELS
        )
        .unwrap()
    });
}
