//! CLI interpreter for the service
use std::{
    io::Write,
    sync::{Arc, Mutex},
};

use clap::Parser;
use tracing::{error, info};

use crate::{
    cardano::start_followers,
    logger, service,
    settings::{DocsSettings, ServiceSettings},
    state::{DeepQueryInspection, InspectionSettings, State},
};

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
                let logger_handle = logger::init(settings.log_level);

                // Unique machine id
                let machine_id = settings.follower_settings.machine_uid;

                let deep_query_mode = if settings.deep_query_inspection {
                    DeepQueryInspection::Enabled
                } else {
                    DeepQueryInspection::Disabled
                };

                let inspection = InspectionSettings {
                    deep_query: Arc::new(Mutex::new(deep_query_mode)),
                    logger_handle,
                };
                let state = Arc::new(State::new(Some(settings.database_url), inspection).await?);
                let event_db = state.event_db();

                tokio::spawn(async move {
                    match service::run(&settings.docs_settings, state.clone()).await {
                        Ok(()) => info!("Endpoints started ok"),
                        Err(err) => {
                            error!("Error starting endpoints {err}");
                        },
                    }
                });

                start_followers(
                    event_db.clone(),
                    settings.follower_settings.check_config_tick,
                    settings.follower_settings.data_refresh_tick,
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
