//! Health endpoints `live`, `started` and `ready` analytics.

use crate::{
    service::api::health::{live_get, ready_get, started_get},
    settings::Settings,
};

/// Updates health endpoints values.
pub(crate) fn update() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();

    if matches!(
        live_get::endpoint(),
        live_get::AllResponses::With(live_get::Responses::NoContent)
    ) {
        reporter::LIVE_INDICATOR
            .with_label_values(&[&api_host_names, service_id])
            .set(1);
    } else {
        reporter::LIVE_INDICATOR
            .with_label_values(&[&api_host_names, service_id])
            .set(0);
    }

    if matches!(
        ready_get::endpoint(),
        ready_get::AllResponses::With(ready_get::Responses::NoContent)
    ) {
        reporter::READY_INDICATOR
            .with_label_values(&[&api_host_names, service_id])
            .set(1);
    } else {
        reporter::READY_INDICATOR
            .with_label_values(&[&api_host_names, service_id])
            .set(0);
    }

    if matches!(
        started_get::endpoint(),
        started_get::AllResponses::With(started_get::Responses::NoContent)
    ) {
        reporter::STARTED_INDICATOR
            .with_label_values(&[&api_host_names, service_id])
            .set(1);
    } else {
        reporter::STARTED_INDICATOR
            .with_label_values(&[&api_host_names, service_id])
            .set(0);
    }
}

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
            "Health `live` endpoint indicator whether its healthy or not, returns the response `204` or something else.",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Health `started` endpoint indicator whether its healthy or not
    pub(crate) static STARTED_INDICATOR: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
                "health_started_indicator",
                "Health `started` endpoint indicator whether its healthy or not, returns the response `204` or something else.",
                &METRIC_LABELS
            )
            .unwrap()
    });

    /// Health `ready` endpoint indicator whether its healthy or not
    pub(crate) static READY_INDICATOR: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
                    "health_ready_indicator",
                    "Health `ready` endpoint indicator whether its healthy or not, returns the response `204` or something else.",
                    &METRIC_LABELS
                )
                .unwrap()
    });
}
