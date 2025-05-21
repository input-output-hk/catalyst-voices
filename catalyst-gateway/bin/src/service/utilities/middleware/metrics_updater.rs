use poem::{
    endpoint::PrometheusExporter, http::{Method, StatusCode}, Endpoint, IntoEndpoint, Request, Response, Result
};
use prometheus::Registry;

pub struct MetricsUpdaterMiddleware {
    exporter: PrometheusExporter,
}

impl MetricsUpdaterMiddleware {
    /// Create a `PrometheusExporter` endpoint.
    pub fn new(registry: Registry) -> Self {
        Self {
            exporter: PrometheusExporter::new(registry),
        }
    }
}

impl Endpoint for MetricsUpdaterMiddleware {
    type Output = Response;

    async fn call(&self, req: Request) -> Result<Self::Output> {
        self.exporter.into_endpoint().call(req).await
    }
}
