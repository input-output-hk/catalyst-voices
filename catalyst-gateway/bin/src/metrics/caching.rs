//! Metrics related to RBAC Registration Chain Caching analytics.

/// All the related RBAC Registration Chain Caching reporting metrics to the Prometheus service are inside
/// this module.
pub(crate) mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_counter_vec, register_int_gauge_vec, CounterVec, IntGaugeVec};

    /// Labels for the metrics.
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// The total number of times a requested item was found in the cache.
    pub(crate) static CACHE_HIT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_hit",
            "The total number of times a requested item was found in the cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// The total number of times a requested item was not found in the cache.
    pub(crate) static CACHE_MISS: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_miss",
            "The total number of times a requested item was not found in the cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// The total number of times the cache has been accessed.
    pub(crate) static CACHE_QUERIES: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_queries",
            "The total number of times the cache has been accessed",
            &METRIC_LABELS
        )
        .unwrap()
    });
}
