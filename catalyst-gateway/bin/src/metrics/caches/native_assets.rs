//! Cache metrics for Native Assets.

use super::cache_metric_inc;
use crate::{db::index::session::CassandraSession, settings::Settings};

/// Represents a persistent session.
const PERSISTENT: bool = true;

/// Update Cache metrics
pub(crate) fn update() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    CassandraSession::get(PERSISTENT).inspect(|session| {
        let cache = session.caches().assets_native();
        reporter::NATIVE_ASSETS_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(cache.weighted_size()).unwrap_or(-1));

        reporter::NATIVE_ASSETS_CACHE_ENTRIES_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(cache.entry_count()).unwrap_or(-1));
    });
}

/// Increment the Native Assets Cache hits count.
pub(crate) fn native_assets_hits_inc() {
    cache_metric_inc!(NATIVE_ASSETS_CACHE_HIT_COUNT);
}

/// Increment the Native Assets Cache misses count.
pub(crate) fn native_assets_misses_inc() {
    cache_metric_inc!(NATIVE_ASSETS_CACHE_MISSES_COUNT);
}

mod reporter {
    //! Prometheus reporter metrics.
    #![allow(clippy::unwrap_used)]

    use std::sync::LazyLock;

    use prometheus::{
        IntCounterVec, IntGaugeVec, register_int_counter_vec, register_int_gauge_vec,
    };

    /// Labels for the metrics
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// Size of the Native Assets cache.
    pub(super) static NATIVE_ASSETS_CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_native_assets_size",
            "Returns the total weighted size of Native Assets entries in this cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Number of entries in the Native Assets cache.
    pub(super) static NATIVE_ASSETS_CACHE_ENTRIES_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "cache_native_assets_entries_count",
                "Returns the number of Native Assets entries in this cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of hits in the Native Assets cache.
    pub(super) static NATIVE_ASSETS_CACHE_HIT_COUNT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "cache_native_assets_hits_count",
                "Returns the number of hits (entries found) in the Native Assets cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of misses in the Native Assets cache.
    pub(super) static NATIVE_ASSETS_CACHE_MISSES_COUNT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "cache_native_assets_misses_count",
                "Returns the number of misses (entries not found) in the Native Assets cache",
                &METRIC_LABELS
            )
            .unwrap()
        });
}
