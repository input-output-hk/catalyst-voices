//! Poem Service for cat-gateway service endpoints.
//!
//! This provides only the primary entrypoint to the service.

use std::sync::Arc;

use poem::{
    endpoint::PrometheusExporter,
    listener::TcpListener,
    middleware::{CatchPanic, Compression, Cors},
    web::CompressionLevel,
    Endpoint, EndpointExt, Route,
};

use crate::{
    service::{
        api::mk_api,
        docs::{docs, favicon},
        utilities::{
            catch_panic::{set_panic_hook, ServicePanicHandler},
            middleware::tracing_mw::{init_prometheus, Tracing},
        },
        Error,
    },
    settings::{get_api_host_names, DocsSettings, API_URL_PREFIX},
    state::State,
};

/// This exists to allow us to add extra routes to the service for testing purposes.
fn mk_app(
    hosts: Vec<String>, base_route: Option<Route>, state: &Arc<State>, settings: &DocsSettings,
) -> impl Endpoint {
    // Get the base route if defined, or a new route if not.
    let base_route = match base_route {
        Some(route) => route,
        None => Route::new(),
    };

    let api_service = mk_api(hosts, settings);
    let docs = docs(&api_service);

    let prometheus_registry = init_prometheus();

    base_route
        .nest(API_URL_PREFIX.as_str(), api_service)
        .nest("/docs", docs)
        .nest("/metrics", PrometheusExporter::new(prometheus_registry))
        .nest("/favicon.ico", favicon())
        .with(Cors::new())
        .with(Compression::new().with_quality(CompressionLevel::Fastest))
        .with(CatchPanic::new().with_handler(ServicePanicHandler))
        .with(Tracing)
        .data(state.clone())
}

/// Get the API docs as a string in the JSON format.
pub(crate) fn get_app_docs(setting: &DocsSettings) -> String {
    let api_service = mk_api(vec![], setting);
    api_service.spec()
}

/// Run the Poem Service
///
/// This provides only the primary entrypoint to the service.
///
/// # Arguments
///
/// *`settings`: &`DocsSetting` - settings for docs
///
/// # Errors
///
/// * `Error::CannotRunService` - cannot run the service
/// * `Error::EventDbError` - cannot connect to the event db
/// * `Error::IoError` - An IO error has occurred.
pub(crate) async fn run(settings: &DocsSettings, state: Arc<State>) -> Result<(), Error> {
    // The address to listen on
    let addr = settings.address;
    tracing::info!("Starting Poem Service ...");
    tracing::info!("Listening on {addr}");

    // Set a custom panic hook, so we can catch panics and not crash the service.
    // And also get data from the panic so we can log it.
    // Panics will cause a 500 to be sent with minimal information we can use to
    // help find them in the logs if they happen in production.
    set_panic_hook();

    let hosts = get_api_host_names(&addr);

    let app = mk_app(hosts, None, &state, settings);

    poem::Server::new(TcpListener::bind(addr))
        .run(app)
        .await
        .map_err(Error::Io)
}

#[cfg(test)]
pub(crate) mod tests {
    // Poem TEST violates our License by using Copyleft libraries.
    // use poem::test::TestClient;
    //
    // use super::*;
    //
    // pub(crate) fn mk_test_app(state: &Arc<State>) -> TestClient<impl Endpoint> {
    // let app = mk_app(vec![], None, state);
    // TestClient::new(app)
    // }
}
