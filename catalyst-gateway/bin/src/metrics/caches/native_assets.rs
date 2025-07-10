//! Cache metrics for Native Assets.

use crate::{
    db::index::queries::caches::txo_assets_by_stake::{entry_count, size as cache_size},
    settings::Settings,
};

mod reporter {
    //! Prometheus reporter metrics.
    use std::sync::LazyLock;

    use prometheus::{register_counter_vec, register_int_gauge_vec, CounterVec, IntGaugeVec};

    /// Labels for the metrics
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// Size of the Native Assets cache.
    pub(crate) static NATIVE_ASSETS_CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_native_assets_size",
            "Returns an approximate total weighted size of Native Assets entries in this cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Approximate number of entries in the Native Assets cache.
    pub(crate) static NATIVE_ASSETS_CACHE_ENTRIES_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "cache_native_assets_entries_count",
                "Returns an approximate number of Native Assets entries in this cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of hits in the Native Assets cache.
    pub(crate) static NATIVE_ASSETS_CACHE_HIT_COUNT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "cache_native_assets_hits_count",
            "Returns an approximate number of Native Assets entries in this cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Number of misses in the Native Assets cache.
    pub(crate) static NATIVE_ASSETS_CACHE_MISSES_COUNT: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "cache_native_assets_misses_count",
                "Returns an approximate number of Native Assets entries in this cache",
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

    reporter::NATIVE_ASSETS_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id, &network])
        .set(i64::try_from(cache_size()).unwrap_or(-1));

    reporter::NATIVE_ASSETS_CACHE_ENTRIES_COUNT
        .with_label_values(&[&api_host_names, service_id, &network])
        .set(i64::try_from(entry_count()).unwrap_or(-1));
}

/// Increment the Native Assets Cache hits count.
pub(crate) fn native_assets_hits_inc() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    reporter::NATIVE_ASSETS_CACHE_HIT_COUNT
        .with_label_values(&[&api_host_names, service_id, &network])
        .inc();
}

/// Increment the Native Assets Cache misses count.
pub(crate) fn native_assets_misses_inc() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    reporter::NATIVE_ASSETS_CACHE_MISSES_COUNT
        .with_label_values(&[&api_host_names, service_id, &network])
        .inc();
}
