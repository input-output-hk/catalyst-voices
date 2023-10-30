//! Main entrypoint to the service
use std::{net::SocketAddr, sync::Arc};

use serde::Serialize;
use tokio::try_join;

use crate::{legacy_service, state::State};

// These Modules contain endpoints
mod api;
mod docs;

// These modules are utility or common types/functions
mod common;
mod poem_service;
mod utilities;

/// Service level errors
#[derive(thiserror::Error, Debug)]
pub(crate) enum Error {
    /// Cannot run the service
    #[error("Cannot run service, error: {0}")]
    CannotRunService(String),
    /// An error with the EventDB
    #[error(transparent)]
    EventDb(#[from] crate::event_db::error::Error),
    /// An IO error has occurred
    #[error(transparent)]
    Io(#[from] std::io::Error),
}

/// Error message
#[derive(Serialize, Debug)]
pub(crate) struct ErrorMessage {
    /// Error message
    error: String,
}

impl ErrorMessage {
    /// Create a new [`ErrorMessage`] with the specified error string.
    pub(crate) fn new(error: String) -> Self {
        Self { error }
    }
}

/// # Run all web services.
///
/// This will currently run both a Axum based Web API, and a Poem based API.
/// This is only for migration until all endpoints are provided by the Poem service.
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
    // Create service addresses to be used during poem migration.
    // Service address is same as official address but +1 to the port.
    let mut legacy_service = *service_addr;
    legacy_service.set_port(legacy_service.port() + 1);

    // This can be simplified to an .await when axum is finally removed.
    try_join!(
        legacy_service::run(&legacy_service, state.clone()),
        poem_service::run(service_addr, state),
    )?;

    Ok(())
}
