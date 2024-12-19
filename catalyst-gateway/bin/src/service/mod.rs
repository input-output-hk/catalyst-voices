//! Main entrypoint to the service

// These Modules contain endpoints
mod api;

mod docs;
// These modules are utility or common types/functions
pub(crate) mod common;
mod poem_service;
pub(crate) mod utilities;

use api::mk_api;
pub(crate) use api::started;
pub(crate) use poem_service::get_app_docs;
use serde_json::{json, Value};
use tracing::error;

/// # Run Catalyst Gateway Service.
///
/// Runs the Poem based API.
///
/// ## Arguments
///
/// `settings`: &`DocsSetting` - settings for docs
/// `state`: `Arc<State>` - the state
///
/// ## Errors
///
/// `Error::CannotRunService` - cannot run the service
/// `Error::EventDbError` - cannot connect to the event db
/// `Error::IoError` - An IO error has occurred.
pub(crate) async fn run() -> anyhow::Result<()> {
    poem_service::run().await
}

/// Retrieve the API specification in JSON format.
pub(crate) fn api_spec() -> Value {
    serde_json::from_str(&mk_api().spec()).unwrap_or_else(|err| {
        error!(id="api_spec", error=?err, "Failed to parse API spec");
        json!({})
    })
}
