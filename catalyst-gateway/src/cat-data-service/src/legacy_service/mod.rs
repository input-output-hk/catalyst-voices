//! Main entrypoint to the Legacy AXUM version of the service
//!
use crate::service::{Error, ErrorMessage};
use crate::state::State;
use axum::{
    extract::MatchedPath,
    http::{Method, Request, StatusCode},
    middleware::{self, Next},
    response::{IntoResponse, Response},
    routing::get,
    Json, Router,
};
use metrics_exporter_prometheus::{Matcher, PrometheusBuilder, PrometheusHandle};
use serde::Serialize;
use std::{future::ready, net::SocketAddr, sync::Arc, time::Instant};
use tokio::try_join;
use tower_http::cors::{Any, CorsLayer};

mod health;
pub(crate) mod types;
mod v0;
mod v1;

pub fn app(state: Arc<State>) -> Router {
    // build our application with a route
    let v0 = v0::v0(state.clone());
    let v1 = v1::v1(state);
    let health = health::health();
    Router::new().nest("/api", v1.merge(v0)).merge(health)
}

fn metrics_app() -> Router {
    let recorder_handle = setup_metrics_recorder();
    Router::new().route("/metrics", get(move || ready(recorder_handle.render())))
}

fn cors_layer() -> CorsLayer {
    CorsLayer::new()
        .allow_methods([Method::GET, Method::POST])
        .allow_origin(Any)
        .allow_headers(Any)
}

async fn run_service(app: Router, addr: &SocketAddr, name: &str) -> Result<(), Error> {
    tracing::info!("Starting {name}...");
    tracing::info!("Listening on {addr}");

    axum::Server::bind(addr)
        .serve(app.into_make_service())
        .await
        .map_err(|e| Error::CannotRunService(e.to_string()))?;
    Ok(())
}

/// # Make the Axum web service.
///
/// ## Arguments
///
/// `service_addr`: &`SocketAddr` - the address to listen on
/// `metrics_addr`: &`Option<SocketAddr>` - the address to listen on for metrics
/// `state`: `Arc<State>` - the state
///
/// ## Errors
///
/// `Error::CannotRunService` - cannot run the service
/// `Error::EventDbError` - cannot connect to the event db
/// `Error::IoError` - An IO error has occurred.
pub async fn run(
    service_addr: &SocketAddr,
    metrics_addr: &Option<SocketAddr>,
    state: Arc<State>,
) -> Result<(), Error> {
    let cors = cors_layer();

    if let Some(metrics_addr) = metrics_addr {
        let service_app = app(state)
            .layer(cors.clone())
            .route_layer(middleware::from_fn(track_metrics));
        let metrics_app = metrics_app().layer(cors);

        try_join!(
            run_service(service_app, service_addr, "service"),
            run_service(metrics_app, metrics_addr, "metrics")
        )?;
    } else {
        let service_app = app(state).layer(cors);

        run_service(service_app, service_addr, "service").await?;
    }
    Ok(())
}

fn handle_result<T: Serialize>(res: Result<T, Error>) -> Response {
    match res {
        Ok(res) => (StatusCode::OK, Json(res)).into_response(),
        Err(Error::EventDb(event_db::error::Error::NotFound(error))) => {
            (StatusCode::NOT_FOUND, Json(ErrorMessage::new(error))).into_response()
        }
        Err(error) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            Json(ErrorMessage::new(error.to_string())),
        )
            .into_response(),
    }
}

fn setup_metrics_recorder() -> PrometheusHandle {
    const EXPONENTIAL_SECONDS: &[f64] = &[
        0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0,
    ];

    PrometheusBuilder::new()
        .set_buckets_for_metric(
            Matcher::Full("http_requests_duration_seconds".to_string()),
            EXPONENTIAL_SECONDS,
        )
        .unwrap()
        .install_recorder()
        .unwrap()
}

async fn track_metrics<T>(req: Request<T>, next: Next<T>) -> impl IntoResponse {
    let start = Instant::now();
    let path = if let Some(matched_path) = req.extensions().get::<MatchedPath>() {
        matched_path.as_str().to_owned()
    } else {
        req.uri().path().to_owned()
    };
    let method = req.method().clone();

    let response = next.run(req).await;

    let latency = start.elapsed().as_secs_f64();
    let status = response.status().as_u16().to_string();

    let labels = [
        ("method", method.to_string()),
        ("path", path),
        ("status", status),
    ];

    metrics::increment_counter!("http_requests_total", &labels);
    metrics::histogram!("http_requests_duration_seconds", latency, &labels);

    response
}

#[cfg(test)]
pub mod tests {
    use axum::body::HttpBody;
    use std::str::FromStr;

    pub async fn response_body_to_json<
        T: HttpBody<Data = impl Into<Vec<u8>>, Error = axum::Error> + Unpin,
    >(
        response: axum::response::Response<T>,
    ) -> Result<serde_json::Value, String> {
        let data: Vec<u8> = response
            .into_body()
            .data()
            .await
            .ok_or("response should have data in a body".to_string())?
            .map_err(|e| e.to_string())?
            .into();

        serde_json::Value::from_str(String::from_utf8(data).map_err(|e| e.to_string())?.as_str())
            .map_err(|e| e.to_string())
    }
}
