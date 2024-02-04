use std::{error::Error, str::FromStr, sync::Arc};

use cardano_chain_follower::{
    network_genesis_values, ChainUpdate, Follower, FollowerConfigBuilder, Network, Point,
};
use serde::{Deserialize, Serialize};

use tracing::{error, info};

use crate::event_db::queries::EventDbQueries;

#[derive(Serialize, Deserialize, Debug)]
struct Config {
    network: String,
    start_from: u64,
    block_hash: String,
    relay: String,
}

/// Start followers as per defined in the config
pub(crate) async fn start_followers(
    configs: Vec<String>, db: Arc<dyn EventDbQueries>,
) -> Result<(), Box<dyn Error>> {
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
        init_follower(config, db.clone()).await?;
    }

    Ok(())
}

/// Initiate single follower
async fn init_follower(config: Config, db: Arc<dyn EventDbQueries>) -> Result<(), Box<dyn Error>> {
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

    let genesis_values = network_genesis_values(&Network::from_str(&config.network)?)
        .expect("obtaining genesis values from follower crate is infallible");

    tokio::spawn(async move {
        loop {
            // wait for interupt

            let chain_update = follower.next().await.expect("infallible");

            match chain_update {
                ChainUpdate::Block(data) => {
                    let block = data.decode().expect("infallible");

                    match db
                        .updates_from_follower(
                            block.slot().try_into().expect("infallible"),
                            config.network.clone(),
                            block
                                .epoch(&genesis_values)
                                .0
                                .try_into()
                                .expect("infallible"),
                            block
                                .wallclock(&genesis_values)
                                .try_into()
                                .expect("infallible"),
                            hex::encode(block.hash()),
                        )
                        .await
                    {
                        Ok(_) => (),
                        Err(err) => {
                            error!("unable to index follower data {:?}", err);
                        },
                    }
                },
                ChainUpdate::Rollback(data) => {
                    let block = data.decode().expect("infallible");

                    info!(
                        "Rollback block NUMBER={} SLOT={} HASH={}",
                        block.number(),
                        block.slot(),
                        hex::encode(block.hash()),
                    );
                },
            }
        }
    });

    Ok(())
}
