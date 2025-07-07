//! Metrics for the TXO Assets Cache

use crate::settings::Settings;

mod reporter {
    //! Prometheus reporter metrics.
    use std::sync::LazyLock;

    use prometheus::{register_int_gauge_vec, IntGaugeVec};

    /// Labels for the metrics
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// Size of the TXO Assets cache.
    pub(crate) static TXO_ASSETS_CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_txo_assets_size",
            "Returns an approximate total weighted size of TXO Assets entries in this cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Approximate number of entries in the TXO Assets cache.
    pub(crate) static TXO_ASSETS_CACHE_ENTRIES_COUNT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_txo_assets_entries_count",
            "Returns an approximate number of TXO Assets entries in this cache",
            &METRIC_LABELS
        )
        .unwrap()
    });
}

/// Update Cache metrics
pub(crate) fn update() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    reporter::TXO_ASSETS_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id, &network])
        .set(0i64);

    reporter::TXO_ASSETS_CACHE_ENTRIES_COUNT
        .with_label_values(&[&api_host_names, service_id, &network])
        .set(0i64);
}
