//! Metrics related to RBAC Registration Chain analytics.

use crate::settings::Settings;

/// Increments the `INVALID_RBAC_REGISTRATION_COUNT` metric.
pub(crate) fn inc_invalid_rbac_reg_count() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    reporter::INVALID_RBAC_REGISTRATION_COUNT
        .with_label_values(&[&api_host_names, service_id, &network])
        .inc();
}

/// All the related RBAC Registration Chain metrics to the Prometheus
/// service are inside this module.
pub(crate) mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_int_counter_vec, IntCounterVec};

    /// Labels for the metrics.
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// This counter increases every when we found invalid RBAC registration during
    /// indexing.
    pub(crate) static INVALID_RBAC_REGISTRATION_COUNT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "indexing_synchronization_count",
                "Number of RBAC indexing synchronizations",
                &METRIC_LABELS
            )
            .unwrap()
        });
}
