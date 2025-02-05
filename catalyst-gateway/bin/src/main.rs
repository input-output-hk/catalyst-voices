//! Catalyst Data Gateway
use clap::Parser;

mod build_info;
mod cardano;
mod cli;
mod db;
mod jinja;
mod logger;
mod metrics;
mod service;
mod settings;
mod utils;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    cli::Cli::parse().exec().await?;
    Ok(())
}
