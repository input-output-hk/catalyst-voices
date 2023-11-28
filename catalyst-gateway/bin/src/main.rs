//! Catalyst Data Gateway
use clap::Parser;

mod cli;
mod event_db;
mod logger;
mod service;
mod settings;
mod state;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    cli::Cli::parse().exec().await?;
    Ok(())
}
