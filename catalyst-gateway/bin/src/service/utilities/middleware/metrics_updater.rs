//! A middleware module wrapping around `prometheus::Registry`.
//! It acts as an endpoint to export metrics data to the Prometheus service.
//! For every request to this endpoint, it will call the `updater` function to update
//! metrics to the latest before sending to the service.

use poem::{
    http::{Method, StatusCode},
    Endpoint, Request, Response, Result,
};
use prometheus::{Encoder, Registry, TextEncoder};

/// The function type to call when a request sent to the endpoint.
type UpdateFn = fn();

/// A Middleware wrapping the Prometheus registry to report as metrics.
///
/// The middleware is originally from `poem::endpoint::PrometheusExporter`.
pub struct MetricsUpdaterMiddleware {
    /// The Prometheus registry.
    registry: Registry,
    /// The updater function, called for every request for this endpoint.
    updater: UpdateFn,
}

impl MetricsUpdaterMiddleware {
    /// Create a `PrometheusExporter` endpoint.
    pub fn new(registry: Registry, updater: UpdateFn) -> Self {
        Self { registry, updater }
    }
}

impl Endpoint for MetricsUpdaterMiddleware {
    type Output = Response;

    async fn call(&self, req: Request) -> Result<Self::Output> {
        if req.method() != Method::GET {
            return Ok(StatusCode::METHOD_NOT_ALLOWED.into());
        }

        (self.updater)();

        let encoder = TextEncoder::new();
        let metric_families = self.registry.gather();
        let mut result = Vec::new();
        match encoder.encode(&metric_families, &mut result) {
            Ok(()) => {
                Ok(Response::builder()
                    .content_type(encoder.format_type())
                    .body(result))
            },
            Err(_) => Err(StatusCode::INTERNAL_SERVER_ERROR.into()),
        }
    }
}
