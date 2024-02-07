//! CLI interpreter for the service
use std::{io::Write, sync::Arc};

use clap::Parser;

use crate::{
    logger, service,
    settings::{DocsSettings, ServiceSettings},
    state::State,
};

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
    Run(ServiceSettings),
    /// Build API docs of the service in the JSON format
    Docs(DocsSettings),
}

impl Cli {
    /// Execute the specified operation.
    ///
    /// This method is asynchronous and returns a `Result` indicating whether the
    /// operation was successful or if an error occurred.
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
                service::run(&settings.docs_settings, state).await?;
                Ok(())
            },
            Self::Docs(settings) => {
                let docs = service::get_app_docs(&settings);
                match settings.output {
                    Some(path) => {
                        let mut docs_file = std::fs::File::create(path)?;
                        docs_file.write_all(docs.as_bytes())?;
                    },
                    None => println!("{docs}"),
                }
                Ok(())
            },
        }
    }
}
