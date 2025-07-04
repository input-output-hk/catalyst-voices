//! Health endpoints `live`, `started` and `ready` analytics.

/// Updates health endpoints values.
pub(crate) fn update() {}

/// All the related health endpoints reporting metrics to the Prometheus service are
/// inside this module.
pub(crate) mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_int_gauge_vec, IntGaugeVec};

    /// Labels for the metrics.
    const METRIC_LABELS: [&str; 2] = ["api_host_names", "service_id"];

    /// Health `live` endpoint indicator whether its healthy or not
    pub(crate) static LIVE_INDICATOR: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "health_live_indicator",
            "Health `live` endpoint indicator whether its healthy or not, returns the repsonse `204` or something else.",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Health `started` endpoint indicator whether its healthy or not
    pub(crate) static STARTED_INDICATOR: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
                "health_started_indicator",
                "Health `started` endpoint indicator whether its healthy or not, returns the repsonse `204` or something else.",
                &METRIC_LABELS
            )
            .unwrap()
    });

    /// Health `ready` endpoint indicator whether its healthy or not
    pub(crate) static READY_INDICATOR: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
                    "health_ready_indicator",
                    "Health `ready` endpoint indicator whether its healthy or not, returns the repsonse `204` or something else.",
                    &METRIC_LABELS
                )
                .unwrap()
    });
}
