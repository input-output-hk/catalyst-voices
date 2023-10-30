//! Main entrypoint to the Legacy AXUM version of the service
//! This whole module is deprecated, so don't worry if its not documented how we would
//! like.
#![allow(clippy::missing_docs_in_private_items)]
use std::{net::SocketAddr, sync::Arc};

use axum::{
    http::{Method, StatusCode},
    response::{IntoResponse, Response},
    Json, Router,
};
use serde::Serialize;
use tower_http::cors::{Any, CorsLayer};

use crate::{
    service::{Error, ErrorMessage},
    state::State,
};

mod health;
pub(crate) mod types;
mod v0;
mod v1;

pub(crate) fn app(state: Arc<State>) -> Router {
    // build our application with a route
    let v0 = v0::v0(state.clone());
    let v1 = v1::v1(state);
    let health = health::health();
    Router::new().nest("/api", v1.merge(v0)).merge(health)
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
pub(crate) async fn run(service_addr: &SocketAddr, state: Arc<State>) -> Result<(), Error> {
    let cors = cors_layer();

    let service_app = app(state).layer(cors);

    run_service(service_app, service_addr, "service").await?;
    Ok(())
}

fn handle_result<T: Serialize>(res: Result<T, Error>) -> Response {
    match res {
        Ok(res) => (StatusCode::OK, Json(res)).into_response(),
        Err(Error::EventDb(crate::event_db::error::Error::NotFound(error))) => {
            (StatusCode::NOT_FOUND, Json(ErrorMessage::new(error))).into_response()
        },
        Err(error) => {
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                Json(ErrorMessage::new(error.to_string())),
            )
                .into_response()
        },
    }
}

// #[cfg(test)]
// pub(crate) mod tests {
// use std::str::FromStr;
//
// use axum::body::HttpBody;
//
// pub(crate) async fn response_body_to_json<
// T: HttpBody<Data = impl Into<Vec<u8>>, Error = axum::Error> + Unpin,
// >(
// response: axum::response::Response<T>,
// ) -> Result<serde_json::Value, String> {
// let data: Vec<u8> = response
// .into_body()
// .data()
// .await
// .ok_or("response should have data in a body".to_string())?
// .map_err(|e| e.to_string())?
// .into();
//
// serde_json::Value::from_str(String::from_utf8(data).map_err(|e|
// e.to_string())?.as_str()) .map_err(|e| e.to_string())
// }
// }
