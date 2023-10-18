//! Stoplight Elements OpenAPI UI
//!
mod stoplight_elements;
use poem::{endpoint::EmbeddedFileEndpoint, get, Route};
use poem_openapi::{OpenApi, OpenApiService, Webhook};
use rust_embed::RustEmbed;

pub(crate) fn docs<T: OpenApi + 'static, W: Webhook + 'static>(
    api_service: &OpenApiService<T, W>,
) -> Route {
    let spec = api_service.spec();

    let swagger_ui = api_service.swagger_ui();
    let rapidoc_ui = api_service.rapidoc();
    let redoc_ui = api_service.redoc();
    let openapi_explorer = api_service.openapi_explorer();
    let stoplight_ui = stoplight_elements::create_endpoint(&spec);

    Route::new()
        .at("/", get(stoplight_ui))
        .nest("/swagger_ui", swagger_ui)
        .nest("/redoc", redoc_ui)
        .nest("/rapidoc", rapidoc_ui)
        .nest("/openapi_explorer", openapi_explorer)
        .at(
            "/cat-data-service.json",
            poem::endpoint::make_sync(move |_| spec.clone()),
        )
}

#[derive(RustEmbed)]
#[folder = "src/service/docs/files"]
pub struct Files;

/// Get an endpoint for favicon.ico
pub(crate) fn favicon() -> Route {
    Route::new().at("/", EmbeddedFileEndpoint::<Files>::new("favicon.ico"))
}
