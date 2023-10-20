//! CLI interpreter for the service
//!
use crate::{logger, service, settings::Settings, state::State};
use clap::Parser;
use std::sync::Arc;

#[derive(thiserror::Error, Debug)]
/// All service errors
pub(crate) enum Error {
    #[error(transparent)]
    /// Service oriented errors
    Service(#[from] service::Error),
    #[error(transparent)]
    /// DB oriented errors
    EventDb(#[from] crate::event_db::error::Error),
}

#[derive(Parser)]
#[clap(rename_all = "kebab-case")]
/// Simple service CLI options
pub(crate) enum Cli {
    /// Run the service
    Run(Settings),
}

impl Cli {
    /// Execute the specified operation.
    ///
    /// This method is asynchronous and returns a `Result` indicating whether the operation was successful or if an error occurred.
    ///
    /// # Errors
    ///
    /// This method can return an error if:
    ///
    /// - Failed to initialize the logger with the specified log level.
    /// - Failed to create a new `State` with the provided database URL.
    /// - Failed to run the service on the specified address.
    pub(crate) async fn exec(self) -> Result<(), Box<dyn std::error::Error>> {
        match self {
            Self::Run(settings) => {
                logger::init(settings.log_level)?;

                let state = Arc::new(State::new(Some(settings.database_url)).await?);
                service::run(&settings.address, state).await?;
                Ok(())
            }
        }
    }
}
