use clap::Parser;

mod cli;
mod legacy_service;
mod logger;
mod service;
mod settings;
mod state;

#[tokio::main]
async fn main() -> Result<(), cli::Error> {
    cli::Cli::parse().exec().await?;
    Ok(())
}
