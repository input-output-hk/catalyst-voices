//! CLI interpreter for the service
use std::{io::Write, sync::Arc};

use clap::Parser;
use tokio::time;
use tracing::{error, info};

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
    pub(crate) async fn exec(self) -> anyhow::Result<()> {
        match self {
            Self::Run(settings) => {
                logger::init(settings.log_level)?;

                let check_config_tick = settings.follower_settings.check_config_tick;
                let data_refresh_tick = settings.follower_settings.data_refresh_tick;

                // Unique machine id
                let machine_id = settings.follower_settings.machine_uid;

                let state = Arc::new(State::new(Some(settings.database_url)).await?);
                let event_db = state.event_db()?;

                tokio::spawn(async move {
                    match service::run(&settings.docs_settings, state.clone()).await {
                        Ok(()) => info!("Endpoints started ok"),
                        Err(err) => {
                            error!("Error starting endpoints {err}");
                        },
                    }
                });

                // tick until config exists
                let mut interval =
                    time::interval(time::Duration::from_secs(check_config_tick.parse::<u64>()?));
                let config = loop {
                    interval.tick().await;

                    match event_db.get_follower_config().await {
                        Ok(config) => break config,
                        Err(err) => error!("no config {:?}", err),
                    }
                };

                start_followers(
                    config,
                    event_db.clone(),
                    data_refresh_tick.parse::<u64>()?,
                    check_config_tick.parse::<u64>()?,
                    machine_id,
                )
                .await?;

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
