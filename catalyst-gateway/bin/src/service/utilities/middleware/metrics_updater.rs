use poem::{
    http::{Method, StatusCode},
    Endpoint, IntoEndpoint, Request, Response, Result,
};
use prometheus::{Encoder, Registry, TextEncoder};

pub struct MetricsUpdaterMiddleware {
    registry: Registry
}

impl MetricsUpdaterMiddleware {
    /// Create a `PrometheusExporter` endpoint.
    pub fn new(registry: Registry) -> Self {
        Self { registry }
    }
}

impl IntoEndpoint for MetricsUpdaterMiddleware {
    type Endpoint = MetricsUpdaterEndpoint;

    fn into_endpoint(self) -> Self::Endpoint {
        MetricsUpdaterEndpoint {
            registry: self.registry.clone(),
        }
    }
}

#[doc(hidden)]
pub struct MetricsUpdaterEndpoint {
    registry: Registry,
}

impl Endpoint for MetricsUpdaterEndpoint {
    type Output = Response;

    async fn call(&self, req: Request) -> Result<Self::Output> {
        if req.method() != Method::GET {
            return Ok(StatusCode::METHOD_NOT_ALLOWED.into());
        }

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
