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

/// Service level errors
#[derive(thiserror::Error, Debug)]
pub(crate) enum Error {
    /// An error with the EventDB
    #[error(transparent)]
    EventDb(#[from] crate::event_db::error::Error),
    /// An IO error has occurred
    #[error(transparent)]
    Io(#[from] std::io::Error),
    /// A mismatch in the expected EventDB schema version
    #[error("expected schema version mismatch")]
    SchemaVersionMismatch,
}

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
pub(crate) async fn run(settings: &DocsSettings, state: Arc<State>) -> Result<(), Error> {
    poem_service::run(settings, state).await
}
