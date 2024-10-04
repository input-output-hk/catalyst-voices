//! Main entrypoint to the service

// These Modules contain endpoints
mod api;

mod docs;
// These modules are utility or common types/functions
mod common;
mod poem_service;
pub(crate) mod utilities;

pub(crate) use api::started;
pub(crate) use poem_service::get_app_docs;

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
