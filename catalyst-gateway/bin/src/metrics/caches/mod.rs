//! Metrics for Cache-related metrics.

pub(crate) mod native_assets;
pub(crate) mod rbac;
pub(crate) mod txo_assets;

/// Increment a metric value by one.
macro_rules! cache_metric_inc {
    ($cache:ident) => {
        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = Settings::cardano_network().to_string();

        reporter::$cache
            .with_label_values(&[&api_host_names, service_id, &network])
            .inc();
    };
}

pub(crate) use cache_metric_inc;

/// Update Cache metrics
pub(crate) fn update() {
    native_assets::update();
    txo_assets::update();
    rbac::update();
}
