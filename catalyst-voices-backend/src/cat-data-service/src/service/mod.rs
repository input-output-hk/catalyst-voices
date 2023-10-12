//! Main entrypoint to the service
//!
use crate::legacy_service;
use crate::state::State;

use serde::Serialize;
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::try_join;

// These Modules contain endpoints
mod api;
mod docs;

// These modules are utility or common types/functions
mod common;
mod poem_service;
mod utilities;

#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("Cannot run service, error: {0}")]
    CannotRunService(String),
    #[error(transparent)]
    EventDb(#[from] event_db::error::Error),
    #[error(transparent)]
    Io(#[from] std::io::Error),
}

#[derive(Serialize, Debug)]
pub struct ErrorMessage {
    error: String,
}

impl ErrorMessage {
    pub fn new(error: String) -> Self {
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
pub async fn run(
    service_addr: &SocketAddr,
    metrics_addr: &Option<SocketAddr>, // TODO Remove this parameter when Axum is removed.
    state: Arc<State>,
) -> Result<(), Error> {
    // Create service addresses to be used during poem migration.
    // Service address is same as official address but +1 to the port.
    let mut legacy_service = *service_addr;
    legacy_service.set_port(legacy_service.port() + 1);

    // This can be simplified to an .await when axum is finally removed.
    try_join!(
        legacy_service::run(&legacy_service, metrics_addr, state.clone()),
        poem_service::run(service_addr, state),
    )?;

    Ok(())
}
