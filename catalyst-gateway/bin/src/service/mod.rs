//! Main entrypoint to the service
use std::sync::Arc;

use crate::{settings::DocsSettings, state::State};

// These Modules contain endpoints
mod api;
mod docs;

// These modules are utility or common types/functions
mod common;
mod poem_service;
mod utilities;

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
pub(crate) async fn run(settings: &DocsSettings, state: Arc<State>) -> anyhow::Result<()> {
    poem_service::run(settings, state).await
}
