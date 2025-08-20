//! Metrics for the TXO Assets Cache

use crate::{db::index::session::CassandraSession, settings::Settings};

mod reporter {
    //! Prometheus reporter metrics.
    use std::sync::LazyLock;

    use prometheus::{
        register_int_counter_vec, register_int_gauge_vec, IntCounterVec, IntGaugeVec,
    };

    /// Labels for the metrics
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// Size of the TXO Assets cache.
    pub(super) static TXO_ASSETS_CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_txo_assets_size",
            "Returns the total weighted size of TXO Assets entries in this cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Number of entries in the TXO Assets cache.
    pub(super) static TXO_ASSETS_CACHE_ENTRIES_COUNT: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_txo_assets_entries_count",
            "Returns the number of TXO Assets entries in this cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Number of hits in the TXO Assets cache.
    pub(super) static TXO_ASSETS_CACHE_HIT_COUNT: LazyLock<IntCounterVec> = LazyLock::new(|| {
        register_int_counter_vec!(
            "cache_txo_assets_hits_count",
            "Returns the number of hits (entries found) in the TXO Assets cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Number of misses in the TXO Assets cache.
    pub(super) static TXO_ASSETS_CACHE_MISSES_COUNT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "cache_txo_assets_misses_count",
                "Returns the number of misses (entries not found) in the TXO Assets cache",
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

    // Onle update persistent session cache size metrics.
    CassandraSession::get(true).inspect(|session| {
        let cache = session.caches().assets_ada();
        reporter::TXO_ASSETS_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(cache.weighted_size()).unwrap_or(-1));

        reporter::TXO_ASSETS_CACHE_ENTRIES_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(cache.entry_count()).unwrap_or(-1));
    });
}

/// Increment the TXO Assets Cache hits count.
pub(crate) fn txo_assets_hits_inc() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    reporter::TXO_ASSETS_CACHE_HIT_COUNT
        .with_label_values(&[&api_host_names, service_id, &network])
        .inc();
}

/// Increment the TXO Assets Cache misses count.
pub(crate) fn txo_assets_misses_inc() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    reporter::TXO_ASSETS_CACHE_MISSES_COUNT
        .with_label_values(&[&api_host_names, service_id, &network])
        .inc();
}
