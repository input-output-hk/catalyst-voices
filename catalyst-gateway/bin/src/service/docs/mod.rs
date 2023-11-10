//! Stoplight Elements `OpenAPI` UI
mod stoplight_elements;
use poem::{endpoint::EmbeddedFileEndpoint, get, Route};
use poem_openapi::{OpenApi, OpenApiService, Webhook};
use rust_embed::RustEmbed;

/// Create the documentation pages where the `OpenAPI` docs can be viewed.
pub(crate) fn docs<T, W>(api_service: &OpenApiService<T, W>) -> Route
where
    T: OpenApi + 'static,
    W: Webhook + 'static,
{
    let swagger_ui = api_service.swagger_ui();
    let rapidoc_ui = api_service.rapidoc();
    let redoc_ui = api_service.redoc();
    let openapi_explorer = api_service.openapi_explorer();
    let stoplight_ui = stoplight_elements::create_endpoint(&api_service.spec());

    Route::new()
        .at("/", get(stoplight_ui))
        .nest("/swagger_ui", swagger_ui)
        .nest("/redoc", redoc_ui)
        .nest("/rapidoc", rapidoc_ui)
        .nest("/openapi_explorer", openapi_explorer)
        .at("/cat-gateway.json", api_service.spec_endpoint())
}

/// Embed static files.
#[derive(RustEmbed)]
#[folder = "src/service/docs/files"]
pub(crate) struct Files;

/// Get an endpoint for favicon.ico
pub(crate) fn favicon() -> Route {
    Route::new().at("/", EmbeddedFileEndpoint::<Files>::new("favicon.ico"))
}
