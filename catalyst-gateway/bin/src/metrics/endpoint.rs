//! Metrics related to endpoint analytics.

use std::sync::LazyLock;

use prometheus::{register_histogram_vec, register_int_counter_vec, HistogramVec, IntCounterVec};

/// Labels for the metrics
const METRIC_LABELS: [&str; 3] = ["endpoint", "method", "status_code"];
/// Labels for the client metrics
const CLIENT_METRIC_LABELS: [&str; 2] = ["client", "status_code"];

// Prometheus Metrics maintained by the service

/// HTTP Request duration histogram.
pub(crate) static HTTP_REQ_DURATION_MS: LazyLock<HistogramVec> = LazyLock::new(|| {
    register_histogram_vec!(
        "http_request_duration_ms",
        "Duration of HTTP requests in milliseconds",
        &METRIC_LABELS
    )
    .unwrap()
});

/// HTTP Request CPU Time histogram.
pub(crate) static HTTP_REQ_CPU_TIME_MS: LazyLock<HistogramVec> = LazyLock::new(|| {
    register_histogram_vec!(
        "http_request_cpu_time_ms",
        "CPU Time of HTTP requests in milliseconds",
        &METRIC_LABELS
    )
    .unwrap()
});

// No Tacho implemented to enable this.
// static ref HTTP_REQUEST_RATE: GaugeVec = register_gauge_vec!(
// "http_request_rate",
// "Rate of HTTP requests per second",
// &METRIC_LABELS
// )
// .unwrap();

/// HTTP Request count histogram.
pub(crate) static HTTP_REQUEST_COUNT: LazyLock<IntCounterVec> = LazyLock::new(|| {
    register_int_counter_vec!(
        "http_request_count",
        "Number of HTTP requests",
        &METRIC_LABELS
    )
    .unwrap()
});

/// Client Request Count histogram.
pub(crate) static CLIENT_REQUEST_COUNT: LazyLock<IntCounterVec> = LazyLock::new(|| {
    register_int_counter_vec!(
        "client_request_count",
        "Number of HTTP requests per client",
        &CLIENT_METRIC_LABELS
    )
    .unwrap()
});
