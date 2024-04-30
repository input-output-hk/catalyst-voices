//! Catalyst Data Gateway
use clap::Parser;

mod cardano;
mod cli;
mod event_db;
mod logger;
mod service;
mod settings;
mod state;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    cli::Cli::parse().exec().await?;
    Ok(())
}
