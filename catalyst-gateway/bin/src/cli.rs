//! CLI interpreter for the service
use std::{io::Write, time::Duration};

use clap::Parser;
use tracing::{error, info};

use crate::{
    cardano::start_followers,
    db::{self, index::session::CassandraSession},
    service::{
        self,
        utilities::health::{
            condition_for_started, is_live, live_counter_reset, service_has_started, set_to_started,
        },
    },
    settings::{DocsSettings, ServiceSettings, Settings},
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
                Settings::init(settings)?;

                let mut tasks = Vec::new();

                info!("Catalyst Gateway - Starting");

                // Start the DB's.
                CassandraSession::init();

                db::event::establish_connection();

                // Start the chain indexing follower.
                start_followers().await?;

                // Start the API service.
                let handle = tokio::spawn(async move {
                    match service::run().await {
                        Ok(()) => info!("Endpoints started ok"),
                        Err(err) => {
                            error!("Error starting endpoints {err}");
                        },
                    }
                });
                tasks.push(handle);

                // Start task to reset the service 'live counter' at a regular interval.
                let handle = tokio::spawn(async move {
                    while is_live() {
                        tokio::time::sleep(Settings::service_live_timeout_interval()).await;
                        live_counter_reset();
                    }
                });
                tasks.push(handle);

                // Start task to wait for the service 'started' flag to be `true`.
                let handle = tokio::spawn(async move {
                    while !service_has_started() {
                        tokio::time::sleep(Duration::from_secs(1)).await;
                        if condition_for_started() {
                            set_to_started();
                        }
                    }
                });
                tasks.push(handle);

                // Run all asynchronous tasks to completion.
                for task in tasks {
                    task.await?;
                }

                info!("Catalyst Gateway - Shut Down");
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
            },
        }

        Ok(())
    }
}
