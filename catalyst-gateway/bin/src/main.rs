//! Catalyst Data Gateway
use clap::Parser;

mod cli;
mod event_db;
mod follower;
mod logger;
mod registration;
mod service;
mod settings;
mod state;
mod util;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    cli::Cli::parse().exec().await?;
    Ok(())
}
