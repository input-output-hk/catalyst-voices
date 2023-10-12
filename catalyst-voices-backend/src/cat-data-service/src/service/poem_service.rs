//! Poem Service for cat-data-service endpoints.
//!
//! This provides only the primary entrypoint to the service.

use crate::service::api::mk_api;
use crate::service::docs::{docs, favicon};
use crate::service::utilities::catch_panic::{set_panic_hook, ServicePanicHandler};
use crate::service::utilities::middleware::{
    chain_axum::ChainAxum,
    tracing_mw::{init_prometheus, Tracing},
};
use crate::service::Error;
use crate::settings::{get_api_hostnames, API_URL_PREFIX};
use crate::state::State;
use poem::endpoint::PrometheusExporter;
use poem::listener::TcpListener;
use poem::middleware::{CatchPanic, Compression, Cors};
use poem::web::CompressionLevel;
use poem::{Endpoint, EndpointExt, Route};
use std::net::SocketAddr;
use std::sync::Arc;

/// This exists to allow us to add extra routes to the service for testing purposes.
pub(crate) fn mk_app(
    hosts: Vec<String>,
    base_route: Option<Route>,
    state: Arc<State>,
) -> impl Endpoint {
    // Get the base route if defined, or a new route if not.
    let base_route = match base_route {
        Some(route) => route,
        None => Route::new(),
    };

    let api_service = mk_api(hosts);
    let docs = docs(&api_service);

    let prometheus_registry = init_prometheus();

    base_route
        .nest(API_URL_PREFIX.as_str(), api_service)
        .nest("/docs", docs)
        .nest("/metrics", PrometheusExporter::new(prometheus_registry))
        .nest("/favicon.ico", favicon())
        .with(Cors::new())
        .with(ChainAxum::new()) // TODO: Remove this once all endpoints are ported.
        .with(Compression::new().with_quality(CompressionLevel::Fastest))
        .with(CatchPanic::new().with_handler(ServicePanicHandler))
        .with(Tracing)
        .data(state.clone())
}

/// Run the Poem Service
///
/// This provides only the primary entrypoint to the service.
///
/// # Arguments
///
/// *`addr`: &`SocketAddr` - the address to listen on
///
/// # Errors
///
/// * `Error::CannotRunService` - cannot run the service
/// * `Error::EventDbError` - cannot connect to the event db
/// * `Error::IoError` - An IO error has occurred.
///
pub async fn run(addr: &SocketAddr, state: Arc<State>) -> Result<(), Error> {
    tracing::info!("Starting Poem Service ...");
    tracing::info!("Listening on {addr}");

    // Set a custom panic hook, so we can catch panics and not crash the service.
    // And also get data from the panic so we can log it.
    // Panics will cause a 500 to be sent with minimal information we can use to
    // help find them in the logs if they happen in production.
    set_panic_hook();

    let hosts = get_api_hostnames(addr);

    let app = mk_app(hosts, None, state);

    poem::Server::new(TcpListener::bind(addr))
        .run(app)
        .await
        .map_err(Error::Io)
}

#[cfg(test)]
pub mod tests {
    use super::*;
    use poem::test::TestClient;

    pub fn mk_test_app(state: Arc<State>) -> TestClient<impl Endpoint> {
        let app = mk_app(vec![], None, state);
        TestClient::new(app)
    }
}
