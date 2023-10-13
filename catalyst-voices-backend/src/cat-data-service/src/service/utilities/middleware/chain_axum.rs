//! Custom middleware to catch any unimplemented endpoints and then pass them to the
//! legacy axum implementation.
//!
//! Allows us to have 1 API and seamlessly migrate unconverted requests.
use crate::legacy_service;
use crate::state::State;

use bytes::Bytes;
use hyper::{HeaderMap, StatusCode, Version};
use poem::{
    async_trait, error::NotFoundError, Endpoint, IntoResponse, Middleware, Request, Response,
    Result,
};
use std::sync::Arc;
use tower::ServiceExt;

/// Middleware to chain call Axum if endpoint is not found.
pub struct ChainAxum;

impl ChainAxum {
    /// Create new `ChainAxum` middleware with any value.
    pub fn new() -> Self {
        ChainAxum {}
    }
}

impl<E> Middleware<E> for ChainAxum
where
    E: Endpoint,
{
    type Output = ChainAxumEndpoint<E>;

    fn transform(&self, ep: E) -> Self::Output {
        ChainAxumEndpoint { inner: ep }
    }
}

/// Endpoint for ChainAxum middleware.
pub struct ChainAxumEndpoint<E> {
    inner: E,
}

struct AxumResponse {
    version: Version,
    status: StatusCode,
    headers: HeaderMap,
    body: Bytes,
}

impl AxumResponse {
    fn new(version: Version, status: StatusCode, headers: HeaderMap, body: Bytes) -> Self {
        AxumResponse {
            version,
            status,
            headers,
            body,
        }
    }
}

impl IntoResponse for AxumResponse {
    fn into_response(self) -> Response {
        let mut resp = Response::builder()
            .status(self.status)
            .version(self.version);

        for (h, v) in self.headers.iter() {
            resp = resp.header(h, v);
        }

        resp.body(self.body)
    }
}

#[async_trait]
impl<E> Endpoint for ChainAxumEndpoint<E>
where
    E: Endpoint,
{
    type Output = Response;

    async fn call(&self, req: Request) -> Result<Self::Output> {
        // Need to copy all the request parts because its consumed by the `call`.
        let (parts, body) = req.into_parts();
        let method = parts.method.clone();
        let uri = parts.uri.clone();
        let version = parts.version;
        let headers = parts.headers.clone();
        let state: &Arc<State> = parts.extensions.get().expect("State must be set.");
        let state = state.clone();
        let body = body.into_bytes().await.unwrap_or_else(|_| Bytes::new());
        let body_copy = body.clone();

        let req = Request::from_parts(parts, poem::Body::from(body));

        match self.inner.call(req).await {
            Ok(res) => Ok(res.into_response()),
            Err(err) => {
                // Only if the error is a 404 (Not found) then try and chain to axum, handler.
                if err.is::<NotFoundError>() {
                    // Build an app instance to run the endpoint.
                    let app = legacy_service::app(state);

                    let mut request = axum::http::Request::builder()
                        .method(method)
                        .uri(uri)
                        .version(version);

                    // Add all the headers from the request.
                    for (h, v) in headers.iter() {
                        request = request.header(h, v);
                    }

                    // Add the body.
                    let request = request
                        .body(body_copy.into())
                        .expect("The Request should always be creatable.");

                    // Call the endpoint
                    let response = app.oneshot(request).await.expect("This is infallible.");
                    let version = response.version();
                    let status = response.status();
                    let headers = response.headers().clone();
                    let body = hyper::body::to_bytes(response.into_body())
                        .await
                        .unwrap_or_else(|_| Bytes::new());

                    let axum_response = AxumResponse::new(version, status, headers, body);

                    Ok(axum_response.into_response())
                } else {
                    Err(err)
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    //use super::*;

    #[tokio::test]
    async fn test_axum_chain() {
        //#[handler(internal)]
        //async fn index(req: &Request) {
        //    assert_eq!(req.extensions().get::<i32>(), Some(&100));
        //}

        //let cli = TestClient::new(index.with(ChainAxum::new(100i32)));
        //cli.get("/").send().await.assert_status_is_ok();
    }
}
