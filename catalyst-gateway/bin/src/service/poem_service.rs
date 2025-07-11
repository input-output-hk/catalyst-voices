//! Poem Service for cat-gateway service endpoints.
//!
//! This provides only the primary entrypoint to the service.

use poem::{
    listener::TcpListener,
    middleware::{CatchPanic, Compression, Cors, SensitiveHeader},
    web::CompressionLevel,
    Endpoint, EndpointExt, Route,
};

use super::{
    common::auth::{api_key::API_KEY_HEADER, rbac::scheme::AUTHORIZATION_HEADER},
    utilities::middleware::{db_check::DatabaseConnectionCheck, node_info::CatGatewayInfo},
};
use crate::{
    service::{
        api::mk_api,
        docs::{docs, favicon},
        utilities::{
            catch_panic::{set_panic_hook, ServicePanicHandler},
            middleware::{metrics_updater::MetricsUpdaterMiddleware, tracing_mw::Tracing},
        },
    },
    settings::Settings,
};

/// This exists to allow us to add extra routes to the service for testing purposes.
fn mk_app(base_route: Option<Route>) -> impl Endpoint {
    // Get the base route if defined, or a new route if not.
    let base_route = match base_route {
        Some(route) => route,
        None => Route::new(),
    };

    let api_service = mk_api();
    let docs = docs(&api_service);

    base_route
        .nest(Settings::api_url_prefix(), api_service)
        .nest("/docs", docs)
        .nest("/metrics", MetricsUpdaterMiddleware::new())
        .nest("/favicon.ico", favicon())
        .with(Cors::new())
        .with(Compression::new().with_quality(CompressionLevel::Fastest))
        .with(CatchPanic::new().with_handler(ServicePanicHandler))
        .with(Tracing)
        .with(DatabaseConnectionCheck)
        .with(CatGatewayInfo)
        .with(
            SensitiveHeader::new()
                .header(API_KEY_HEADER)
                .header(AUTHORIZATION_HEADER)
                .request_only(),
        )
}

/// Get the API docs as a string in the JSON format.
pub(crate) fn get_app_docs() -> String {
    let api_service = mk_api();
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
pub(crate) async fn run() -> anyhow::Result<()> {
    // The address to listen on
    tracing::info!(
        ServiceAddr = Settings::bound_address().to_string(),
        "Starting Cat-Gateway API Service ..."
    );

    // Set a custom panic hook, so we can catch panics and not crash the service.
    // And also get data from the panic so we can log it.
    // Panics will cause a 500 to be sent with minimal information we can use to
    // help find them in the logs if they happen in production.
    set_panic_hook();

    let app = mk_app(None);

    Ok(
        poem::Server::new(TcpListener::bind(Settings::bound_address()))
            .run(app)
            .await?,
    )
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
