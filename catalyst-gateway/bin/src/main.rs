//! Catalyst Data Gateway
use clap::Parser;

mod build_info;
mod cardano;
mod cli;
#[allow(dead_code)]
mod event_db;
mod logger;
mod service;
mod settings;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    cli::Cli::parse().exec().await?;
    Ok(())
}
