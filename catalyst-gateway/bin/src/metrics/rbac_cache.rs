//! Metrics related to RBAC Registration Chain Caching analytics.

use std::{
    sync::atomic::{AtomicBool, Ordering},
    thread,
    time::Duration,
};

use catalyst_types::catalyst_id::CatalystId;
use rbac_registration::registration::cardano::RegistrationChain;

use crate::{
    rbac_cache::{
        event::{EventTarget, RbacCacheManagerEvent as Event},
        RBAC_CACHE,
    },
    settings::Settings,
};

/// This is to prevent the init function from accidentally being called multiple times.
static IS_INITIALIZED: AtomicBool = AtomicBool::new(false);

/// Starts a background thread to periodically update Chain Follower metrics.
///
/// This function spawns a thread that updates the Chain Follower metrics
/// at regular intervals defined by `METRICS_FOLLOWER_INTERVAL`.
pub(crate) fn init_metrics_reporter() {
    if IS_INITIALIZED.swap(true, Ordering::SeqCst) {
        return;
    }

    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    // for sending metrics periodically
    thread::spawn(move || {
        reporter::MAX_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(0).unwrap_or(-1));

        loop {
            let rbac_entries = RBAC_CACHE.rbac_entries();

            let chain_size = size_of::<RegistrationChain>();
            let key_size = size_of::<CatalystId>();

            let approx_mem_used = (chain_size + key_size) * rbac_entries;

            reporter::CACHING_RBAC_ENTRIES
                .with_label_values(&[&api_host_names, service_id, &network])
                .set(i64::try_from(rbac_entries).unwrap_or(-1));
            reporter::CACHE_SIZE
                .with_label_values(&[&api_host_names, service_id, &network])
                .set(i64::try_from(approx_mem_used).unwrap_or(-1));

            thread::sleep(Duration::from_secs(1));
        }
    });

    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    // for sending metrics on events
    RBAC_CACHE.add_event_listener(Box::new(move |event: &Event| {
        if let Event::Initialized { start_up_time } = event {
            reporter::START_UP_TIME
                .with_label_values(&[&api_host_names, service_id, &network])
                .set(i64::try_from(start_up_time.as_millis()).unwrap_or(-1));
        }
        if let Event::RbacRegistrationChainAdded { .. } = event {}
        if let Event::CacheAccessed {
            is_found, latency, ..
        } = event
        {
            reporter::CACHE_ACCESS
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();

            if *is_found {
                reporter::CACHE_HIT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();
                reporter::LATENCY
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .observe(latency.as_secs_f64());
            } else {
                reporter::CACHE_MISS
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();
            }
        }
    }));
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
