//! Catalyst Data Gateway
use clap::Parser;

mod cli;
mod event_db;
mod legacy_service;
mod logger;
mod service;
mod service_settings;
mod state;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    cli::Cli::parse().exec().await?;
    Ok(())
}
