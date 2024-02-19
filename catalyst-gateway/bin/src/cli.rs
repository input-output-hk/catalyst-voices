//! CLI interpreter for the service

use std::{env, io::Write, sync::Arc};

use clap::Parser;
use tokio::time;
use tracing::error;

use crate::{
    follower::start_followers,
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
                let event_db = state.event_db()?;

                // Tick every N seconds until config exists in db
                let check_config_tick = env::var("CHECK_CONFIG_TICK")?;

                // tick until config exists
                let mut interval =
                    time::interval(time::Duration::from_secs(check_config_tick.parse::<u64>()?));
                let config = loop {
                    interval.tick().await;

                    match event_db.get_config().await.map(|config| config) {
                        Ok(config) => break config,
                        Err(err) => error!("no config {:?}", err),
                    }
                };

                // Tick every N seconds until data is stale enough to update
                let data_refresh_tick = env::var("DATA_REFRESH_TICK")?;

                let _ = start_followers(
                    config,
                    event_db.clone(),
                    data_refresh_tick.parse::<u64>()?,
                    check_config_tick.parse::<u64>()?,
                )
                .await?;

                service::run(&settings.address, state).await?;
                Ok(())
            },
            Self::Docs(settings) => {
                let docs = service::get_app_docs();
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
