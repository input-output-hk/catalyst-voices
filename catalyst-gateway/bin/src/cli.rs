//! CLI interpreter for the service
use std::io::Write;

use clap::Parser;
use tracing::{error, info};

use crate::{
    cardano::start_followers, db::{self, index::session::CassandraSession}, metrics::memory::MemoryMetrics, service::{self, started}, settings::{DocsSettings, ServiceSettings, Settings}
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
                MemoryMetrics::start_metrics_updater();
                
                Settings::init(settings)?;

                let mut tasks = Vec::new();

                info!("Catalyst Gateway - Starting");

                // Start the DB's
                CassandraSession::init();
                db::event::establish_connection();

                // Start the chain indexing follower.
                start_followers().await?;

                let handle = tokio::spawn(async move {
                    match service::run().await {
                        Ok(()) => info!("Endpoints started ok"),
                        Err(err) => {
                            error!("Error starting endpoints {err}");
                        },
                    }
                });
                tasks.push(handle);

                started();

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
