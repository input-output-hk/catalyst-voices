//! Metrics related to RBAC Registration Chain Caching analytics.

use std::sync::atomic::{AtomicBool, Ordering};

use crate::{
    rbac_cache::{
        event::{EventTarget, RbacCacheManagerEvent as Event},
        RBAC_CACHE,
    },
    settings::Settings,
};

/// This is to prevent the init function from accidentally being called multiple times.
static IS_INITIALIZED: AtomicBool = AtomicBool::new(false);

/// Starts an event listener to `RBAC_CACHE` and listens for changes as metrics.
pub(crate) fn init_metrics_reporter() {
    if IS_INITIALIZED.swap(true, Ordering::SeqCst) {
        return;
    }

    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    RBAC_CACHE.add_event_listener(Box::new(move |event: &Event| {
        if let Event::Initialized { start_up_time } = event {
            reporter::START_UP_TIME
                .with_label_values(&[&api_host_names, service_id, &network])
                .set(i64::try_from(start_up_time.as_millis()).unwrap_or(-1));
        }
        if let Event::CacheAccessed {
            is_found,
            is_persistent,
            latency,
            ..
        } = event
        {
            if *is_persistent {
                reporter::PERSISTENT_ACCESS
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();

                if *is_found {
                    reporter::PERSISTENT_HIT
                        .with_label_values(&[&api_host_names, service_id, &network])
                        .inc();
                } else {
                    reporter::PERSISTENT_MISS
                        .with_label_values(&[&api_host_names, service_id, &network])
                        .inc();
                }
            } else {
                reporter::VOLATILE_ACCESS
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();

                if *is_found {
                    reporter::VOLATILE_HIT
                        .with_label_values(&[&api_host_names, service_id, &network])
                        .inc();
                } else {
                    reporter::VOLATILE_MISS
                        .with_label_values(&[&api_host_names, service_id, &network])
                        .inc();
                }
            }

            if *is_found {
                reporter::LATENCY
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .observe(latency.as_secs_f64());
            }
        }
    }));
}

/// Updates `MAX_CACHE_SIZE`, `CACHING_RBAC_ENTRIES`, and `CACHE_SIZE` metrics to current
/// values.
pub(crate) fn update() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    let rbac_entries = RBAC_CACHE.rbac_entries();

    reporter::MAX_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id, &network])
        .set(i64::try_from(Settings::rbac_cache_max_size()).unwrap_or(-1));
    reporter::RBAC_CHAIN_ENTRIES
        .with_label_values(&[&api_host_names, service_id, &network])
        .set(i64::try_from(rbac_entries).unwrap_or(-1));
    // TODO: add size approximation on storage caching when it's available
    reporter::CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id, &network])
        .set(0);
}

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

    /// Total count of cache hits for persistent.
    pub(crate) static PERSISTENT_HIT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "cache_persistent_hit",
            "Total count of cache hits for persistent",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total count of cache misses for persistent.
    pub(crate) static PERSISTENT_MISS: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "cache_persistent_miss",
            "Total count of cache misses for persistent",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total count of cache access attempts for persistent.
    pub(crate) static PERSISTENT_ACCESS: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "cache_persistent_access",
            "Total count of cache access attempts for persistent",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total count of cache hits for volatile.
    pub(crate) static VOLATILE_HIT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "cache_volatile_hit",
            "Total count of cache hits for volatile",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total count of cache misses for volatile.
    pub(crate) static VOLATILE_MISS: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "cache_volatile_miss",
            "Total count of cache misses for volatile",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total count of cache access attempts for volatile.
    pub(crate) static VOLATILE_ACCESS: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "cache_volatile_access",
            "Total count of cache access attempts for volatile",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Duration measured in milliseconds for accessing cache on a cache hit.
    pub(crate) static LATENCY: LazyLock<HistogramVec> = LazyLock::new(|| {
        register_histogram_vec!(
            "cache_latency",
            "Duration measured in milliseconds for accessing cache on a cache hit",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total storage space in bytes currently using for RBAC caching.
    pub(crate) static CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_size",
            "Total storage space in bytes currently using for RBAC caching",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Maximum storage space in bytes for RBAC caching.
    pub(crate) static MAX_CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_max_size",
            "Maximum storage space in bytes for RBAC caching",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total time in milliseconds taken to set up RBAC caching service to be operational.
    pub(crate) static START_UP_TIME: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_start_up_time",
            "Total time in milliseconds taken to set up RBAC caching service to be operational",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Total number of RBAC registration chain entries being stored as cache.
    pub(crate) static RBAC_CHAIN_ENTRIES: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "cache_rbac_chain_entries",
            "Total number of RBAC registration chain entries being stored as cache",
            &METRIC_LABELS
        )
        .unwrap()
    });
}
