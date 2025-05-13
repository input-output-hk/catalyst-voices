//! Metrics related to RBAC Registration Chain Caching analytics.

/// All the related RBAC Registration Chain Caching reporting metrics to the Prometheus
/// service are inside this module.
pub(crate) mod reporter {
    use std::sync::LazyLock;

    use prometheus::{
        register_counter_vec, register_histogram_vec, register_int_gauge_vec, CounterVec,
        HistogramVec, IntGaugeVec,
    };

    /// Labels for the metrics.
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// Total count of cache hits.
    pub(crate) static CACHE_HIT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!("cache_hit", "Total count of cache hits", &METRIC_LABELS).unwrap()
    });

    /// Total count of cache misses.
    pub(crate) static CACHE_MISS: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!("cache_miss", "Total count of cache misses", &METRIC_LABELS).unwrap()
    });

    /// Total count of cache access attempts.
    pub(crate) static CACHE_ACCESS: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "cache_access",
            "Total count of cache access attempts",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Duration measured in milliseconds for accessing cache on a cache hit.
    pub(crate) static LATENCY: LazyLock<HistogramVec> = LazyLock::new(|| {
        register_histogram_vec!(
            "latency",
            "Duration measured in milliseconds for accessing cache on a cache hit",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total space in bytes currently using for RBAC caching.
    pub(crate) static CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_size",
            "Total space in bytes currently using for RBAC caching",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Maximum space in bytes for RBAC caching.
    pub(crate) static MAX_CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "max_cache_size",
            "Maximum space in bytes for RBAC caching",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total time in milliseconds taken to set up RBAC caching service to be operational.
    pub(crate) static START_UP_TIME: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "start_up_time",
            "Total time in milliseconds taken to set up RBAC caching service to be operational",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total number of RBAC registration chain entries being stored as cache.
    pub(crate) static CACHING_RBAC_ENTRIES: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "caching_rbac_entries",
            "Total number of RBAC registration chain entries being stored as cache",
            &METRIC_LABELS
        )
        .unwrap()
    });
}
