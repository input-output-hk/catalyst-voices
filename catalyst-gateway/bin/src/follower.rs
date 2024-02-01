//use cardano_chain_follower::{ChainUpdate, Follower, FollowerConfigBuilder, Network, Point};

use std::{error::Error, str::FromStr};

use cardano_chain_follower::{ChainUpdate, Follower, FollowerConfigBuilder, Network, Point};
use serde::{Deserialize, Serialize};
use tracing::{error, info};

#[derive(Serialize, Deserialize, Debug)]
struct Config {
    network: String,
    start_from: u64,
    block_hash: String,
    relay: String,
}

pub async fn start_followers(configs: Vec<String>) -> Result<(), Box<dyn Error>> {
    let mut errors = vec![];

    let configs: Vec<Config> = configs
        .iter()
        .map(|config| serde_json::from_str(&config))
        .filter_map(|r| r.map_err(|e| errors.push(e)).ok())
        .collect();

    if !errors.is_empty() {
        error!("errors parsing config {:?}", errors);
    }

    for config in configs {
        info!("starting follower for {:?}", config.network);
        init_follower(config).await?;
    }

    Ok(())
}

/// Initiate single follower
async fn init_follower(config: Config) -> Result<(), Box<dyn Error>> {
    // Defaults to start following from the tip.
    let follower_cfg = FollowerConfigBuilder::default()
        .follow_from(Point::new(
            config.start_from,
            hex::decode(config.block_hash)?,
        ))
        .build();

    let mut follower = Follower::connect(
        &config.relay,
        Network::from_str(&config.network)?,
        follower_cfg,
    )
    .await?;

    // Wait for 3 chain updates and shutdown.
    for _ in 0..3 {
        let chain_update = follower.next().await?;

        match chain_update {
            ChainUpdate::Block(data) => {
                let block = data.decode()?;

                println!(
                    "New block NUMBER={} SLOT={} HASH={}",
                    block.number(),
                    block.slot(),
                    hex::encode(block.hash()),
                );
            },
            ChainUpdate::Rollback(data) => {
                let block = data.decode()?;

                println!(
                    "Rollback block NUMBER={} SLOT={} HASH={}",
                    block.number(),
                    block.slot(),
                    hex::encode(block.hash()),
                );
            },
        }
    }

    // Waits for the follower background task to exit.
    follower.close().await?;

    Ok(())
}
