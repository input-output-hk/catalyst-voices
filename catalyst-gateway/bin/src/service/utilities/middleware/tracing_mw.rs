//! Full Tracing and metrics middleware.
use std::{sync::LazyLock, time::Instant};

use cpu_time::ProcessTime; // ThreadTime doesn't work.
use poem::{
    http::{header, HeaderMap},
    web::RealIp,
    Endpoint, Error, FromRequest, IntoResponse, Middleware, PathPattern, Request, Response, Result,
};
use poem_openapi::OperationId;
use prometheus::{
    default_registry, register_histogram_vec, register_int_counter_vec, HistogramVec,
    IntCounterVec, Registry,
};
use tracing::{error, field, Instrument, Level, Span};
use ulid::Ulid;
use uuid::Uuid;

use crate::{settings::Settings, utils::blake2b_hash::generate_uuid_string_from_data};

/// Labels for the metrics
const METRIC_LABELS: [&str; 3] = ["endpoint", "method", "status_code"];
/// Labels for the client metrics
const CLIENT_METRIC_LABELS: [&str; 2] = ["client", "status_code"];

// Prometheus Metrics maintained by the service

/// HTTP Request duration histogram.
static HTTP_REQ_DURATION_MS: LazyLock<HistogramVec> = LazyLock::new(|| {
    #[allow(clippy::ignored_unit_patterns)]
    register_histogram_vec!(
        "http_request_duration_ms",
        "Duration of HTTP requests in milliseconds",
        &METRIC_LABELS
    )
    .unwrap()
});

/// HTTP Request CPU Time histogram.
static HTTP_REQ_CPU_TIME_MS: LazyLock<HistogramVec> = LazyLock::new(|| {
    #[allow(clippy::ignored_unit_patterns)]
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
static HTTP_REQUEST_COUNT: LazyLock<IntCounterVec> = LazyLock::new(|| {
    #[allow(clippy::ignored_unit_patterns)]
    register_int_counter_vec!(
        "http_request_count",
        "Number of HTTP requests",
        &METRIC_LABELS
    )
    .unwrap()
});

/// Client Request Count histogram.
static CLIENT_REQUEST_COUNT: LazyLock<IntCounterVec> = LazyLock::new(|| {
    #[allow(clippy::ignored_unit_patterns)]
    register_int_counter_vec!(
        "client_request_count",
        "Number of HTTP requests per client",
        &CLIENT_METRIC_LABELS
    )
    .unwrap()
});

// Currently no way to get these values. TODO.
// Panic Request Count histogram.
// static PANIC_REQUEST_COUNT: LazyLock<IntCounterVec> = LazyLock::new(|| {
// #[allow(clippy::ignored_unit_patterns)]
// register_int_counter_vec!(
// "panic_request_count",
// "Number of HTTP requests that panicked",
// &METRIC_LABELS
// )
// .unwrap()
// });

// Currently no way to get these values without reading the whole response which is BAD.
// static ref HTTP_REQUEST_SIZE_BYTES: HistogramVec = register_histogram_vec!(
// "http_request_size_bytes",
// "Size of HTTP requests in bytes",
// &METRIC_LABELS
// )
// .unwrap();
// static ref HTTP_RESPONSE_SIZE_BYTES: HistogramVec = register_histogram_vec!(
// "http_response_size_bytes",
// "Size of HTTP responses in bytes",
// &METRIC_LABELS
// )
// .unwrap();

/// Middleware for [`tracing`](https://crates.io/crates/tracing).
#[derive(Default)]
pub(crate) struct Tracing;

impl<E: Endpoint> Middleware<E> for Tracing {
    type Output = TracingEndpoint<E>;

    fn transform(&self, ep: E) -> Self::Output {
        TracingEndpoint { inner: ep }
    }
}

/// Endpoint for `Tracing` middleware.
pub(crate) struct TracingEndpoint<E> {
    /// Inner endpoint
    inner: E,
}

/// Given a Clients IP Address, return the anonymized version of it.
fn anonymize_ip_address(remote_addr: &str) -> String {
    let addr: Vec<String> = vec![remote_addr.to_string()];
    generate_uuid_string_from_data(Settings::client_id_key(), &addr)
}

/// Get an anonymized client ID from the request.
///
/// This simply takes the clients IP address,
/// adds a supplied key to it, and hashes the result.
///
/// The Hash is unique per client IP, but not able to
/// be reversed or analyzed without both the client IP and the key.
async fn anonymous_client_id(req: &Request) -> String {
    let remote_addr = RealIp::from_request_without_body(req)
        .await
        .ok()
        .and_then(|real_ip| real_ip.0)
        .map_or_else(|| req.remote_addr().to_string(), |addr| addr.to_string());

    anonymize_ip_address(&remote_addr)
}

/// Data we collected about the response
struct ResponseData {
    /// Duration of the request
    duration: f64,
    /// CPU time of the request
    cpu_time: f64,
    /// Status code returned
    status_code: u16,
    /// Endpoint name
    endpoint: String,
    // panic: bool,
}

impl ResponseData {
    /// Create a new `ResponseData` set from the response.
    /// In the process add relevant data to the span from the response.
    fn new(
        duration: f64, cpu_time: f64, resp: &Response, panic: Option<Uuid>, span: &Span,
    ) -> Self {
        // The OpenAPI Operation ID of this request.
        let oid = resp
            .data::<OperationId>()
            .map_or("Unknown".to_string(), std::string::ToString::to_string);

        let status = resp.status().as_u16();

        // Get the endpoint (path pattern) (this prevents metrics explosion).
        let endpoint = resp.data::<PathPattern>();
        let endpoint = endpoint.map_or("Unknown".to_string(), |endpoint| {
            // For some reason path patterns can have trailing slashes, so remove them.
            endpoint.0.trim_end_matches('/').to_string()
        });

        // Distinguish between "internal" endpoints and truly unknown endpoints.

        span.record("duration_ms", duration);
        span.record("cpu_time_ms", cpu_time);
        span.record("oid", &oid);
        span.record("status", status);
        span.record("endpoint", &endpoint);

        // Record the panic field in the span if it was set.
        if let Some(panic) = panic {
            span.record("panic", panic.to_string());
        }

        add_interesting_headers_to_span(span, "resp", resp.headers());

        Self {
            duration,
            cpu_time,
            status_code: status,
            endpoint,
            // panic: panic.is_some(),
        }
    }
}

/// Add all interesting headers to the correct fields in a span.
/// This logic is the same for both requests and responses.
fn add_interesting_headers_to_span(span: &Span, prefix: &str, headers: &HeaderMap) {
    let size_field = prefix.to_string() + "_size";
    let content_type_field = prefix.to_string() + "_content_type";
    let encoding_field = prefix.to_string() + "_encoding";

    // Record request size if its specified.
    if let Some(size) = headers.get(header::CONTENT_LENGTH) {
        if let Ok(size) = size.to_str() {
            span.record(size_field.as_str(), size);
        }
    }

    // Record request content type if its specified.
    if let Some(content_type) = headers.get(header::CONTENT_TYPE) {
        if let Ok(content_type) = content_type.to_str() {
            span.record(content_type_field.as_str(), content_type);
        }
    }

    // Record request encoding if its specified.
    if let Some(encoding) = headers.get(header::CONTENT_ENCODING) {
        if let Ok(encoding) = encoding.to_str() {
            span.record(encoding_field.as_str(), encoding);
        }
    }
}

/// Make a span from the request
async fn mk_request_span(req: &Request) -> (Span, String, String, String) {
    let client_id = anonymous_client_id(req).await;
    let conn_id = Ulid::new();

    let uri_path = req.uri().path().to_string();
    let uri_query = req.uri().query().unwrap_or("").to_string();

    let method = req.method().to_string();

    let span = tracing::span!(
        target: "Endpoint",
        Level::INFO,
        "request",
        client = %client_id,
        conn = %conn_id,
        version = ?req.version(),
        method = %method,
        path = %uri_path,
        query_size = field::Empty,
        req_size = field::Empty,
        req_content_type = field::Empty,
        req_encoding = field::Empty,
        resp_size = field::Empty,
        resp_content_type = field::Empty,
        resp_encoding = field::Empty,
        endpoint = field::Empty,
        duration_ms = field::Empty,
        cpu_time_ms = field::Empty,
        oid = field::Empty,
        status = field::Empty,
        panic = field::Empty,
    );

    // Record query size (To see if we are sent enormous queries).
    if !uri_query.is_empty() {
        span.record("query_size", uri_query.len());
    }

    add_interesting_headers_to_span(&span, "req", req.headers());

    // Try and get the endpoint as a path pattern (this prevents metrics explosion).
    if let Some(endpoint) = req.data::<PathPattern>() {
        let endpoint = endpoint.0.trim_end_matches('/').to_string();
        span.record("endpoint", endpoint);
    }

    // Try and get the endpoint as a path pattern (this prevents metrics explosion).
    if let Some(oid) = req.data::<OperationId>() {
        span.record("oid", oid.0.to_string());
    }

    (span, uri_path, method, client_id)
}

impl<E: Endpoint> Endpoint for TracingEndpoint<E> {
    type Output = Response;

    async fn call(&self, req: Request) -> Result<Self::Output> {
        // Construct the span from the request.
        let (span, uri_path, method, client_id) = mk_request_span(&req).await;

        let inner_span = span.clone();

        let (response, resp_data) = async move {
            let now = Instant::now();
            let now_proc = ProcessTime::now();

            let resp = self.inner.call(req).await;

            #[allow(clippy::cast_precision_loss)] // Precision loss is acceptable for this timing.
            let duration_proc = now_proc.elapsed().as_micros() as f64 / 1000.0;

            #[allow(clippy::cast_precision_loss)] // Precision loss is acceptable for this timing.
            let duration = now.elapsed().as_micros() as f64 / 1000.0;

            match resp {
                Ok(resp) => {
                    // let panic = if let Some(panic) = resp.downcast_ref::<ServerError>() {
                    // Add panic ID to the span.
                    //    Some(panic.id());
                    //} else {
                    //    None
                    //};

                    let resp = resp.into_response();

                    let response_data =
                        ResponseData::new(duration, duration_proc, &resp, None, &inner_span);

                    (Ok(resp), response_data)
                },
                Err(err) => {
                    // let panic = if let Some(panic) = err.downcast_ref::<ServerError>() {
                    // Add panic ID to the span.
                    //    Some(panic.id());
                    //} else {
                    //    None
                    //};
                    let panic: Option<Uuid> = None;

                    // Get the error message, and also for now, log the error to ensure we are
                    // preserving all data.
                    error!(err = ?err, "HTTP Response Error:");
                    // Only way I can see to get the message, may not be perfect.
                    let error_message = err.to_string();

                    // Convert the error into a response, so we can deal with the error
                    let resp = err.into_response();

                    let response_data =
                        ResponseData::new(duration, duration_proc, &resp, panic, &inner_span);

                    // Convert the response back to an error, and try and recover the message.
                    let mut error = Error::from_response(resp);
                    if !error_message.is_empty() {
                        error.set_error_message(&error_message);
                    }

                    (Err(error), response_data)
                },
            }
        }
        .instrument(span.clone())
        .await;

        span.in_scope(|| {
            // We really want to use the path_pattern from the response, but if not set use the path
            // from the request.
            let path = if resp_data.endpoint.is_empty() {
                uri_path
            } else {
                resp_data.endpoint
            };

            HTTP_REQ_DURATION_MS
                .with_label_values(&[&path, &method, &resp_data.status_code.to_string()])
                .observe(resp_data.duration);
            HTTP_REQ_CPU_TIME_MS
                .with_label_values(&[&path, &method, &resp_data.status_code.to_string()])
                .observe(resp_data.cpu_time);
            // HTTP_REQUEST_RATE
            //.with_label_values(&[&uri_path, &method, &response.status_code.to_string()])
            //.inc();
            HTTP_REQUEST_COUNT
                .with_label_values(&[&path, &method, &resp_data.status_code.to_string()])
                .inc();
            CLIENT_REQUEST_COUNT
                .with_label_values(&[&client_id, &resp_data.status_code.to_string()])
                .inc();
            // HTTP_REQUEST_SIZE_BYTES
            //.with_label_values(&[&uri_path, &method, &response.status_code.to_string()])
            //.observe(response.body().len() as f64);
        });

        response
    }
}

/// Initialize Prometheus metrics.
///
/// ## Returns
///
/// Returns the default prometheus registry.
#[must_use]
pub(crate) fn init_prometheus() -> Registry {
    default_registry().clone()
}
