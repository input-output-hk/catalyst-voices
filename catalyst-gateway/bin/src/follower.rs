use std::{error::Error, str::FromStr, sync::Arc};

use async_recursion::async_recursion;
use cardano_chain_follower::{
    network_genesis_values, ChainUpdate, Follower, FollowerConfigBuilder, Network, Point,
};

use tokio::time;
use tracing::{error, info};

use crate::{
    cli::CHECK_CONFIG_TICK,
    event_db::queries::{
        event::config::{FollowerMeta, NetworkMeta},
        EventDbQueries,
    },
};

// Tick until data is stale and ready to update
pub const DATA_STALE_TICK: u64 = 5;

#[async_recursion]
/// Start followers as per defined in the config
pub(crate) async fn start_followers(
    configs: (Vec<NetworkMeta>, FollowerMeta), db: Arc<dyn EventDbQueries>,
) -> Result<(), Box<dyn Error>> {
    let mut follower_tasks = Vec::new();

    for config in &configs.0 {
        info!("starting follower for {:?}", config.network);

        // tick until data is stale then start followers
        let mut interval = time::interval(time::Duration::from_secs(DATA_STALE_TICK));
        let task_handler = loop {
            interval.tick().await;
            let (slot_no, block_hash, last_updated) =
                db.bootstrap_follower_from(config.network.clone()).await?;

            // threshold which defines if data is stale and ready to update or not
            if chrono::offset::Utc::now().timestamp() - last_updated.timestamp()
                > configs.1.timing_pattern.into()
            {
                info!(
                    "Last update is stale for network {} - ready to update, starting follower now.",
                    config.network
                );
                let task_handler = init_follower(
                    config.network.clone(),
                    config.relay.clone(),
                    slot_no,
                    block_hash,
                    db.clone(),
                )
                .await?;
                break task_handler;
            } else {
                info!(
                    "Data is still fresh for network {}, tick until data is stale",
                    config.network
                );
            }
        };

        follower_tasks.push(task_handler);
    }

    let mut interval = time::interval(time::Duration::from_secs(CHECK_CONFIG_TICK));
    let config = loop {
        interval.tick().await;
        match db.get_config().await.map(|config| config) {
            Ok(config) => {
                if configs != config {
                    info!("Config has changed! restarting");
                    break config;
                }
            },
            Err(err) => error!("No config {:?}", err),
        }
    };

    info!("Terminating followers");
    for task in follower_tasks {
        task.abort()
    }

    info!("Restarting followers with new config");
    start_followers(config, db).await?;

    Ok(())
}

/// Initiate single follower
async fn init_follower(
    network: String, relay: String, slot_no: i64, block_hash: String, db: Arc<dyn EventDbQueries>,
) -> Result<tokio::task::JoinHandle<()>, Box<dyn Error>> {
    // Defaults to start following from the tip.
    let follower_cfg = FollowerConfigBuilder::default()
        .follow_from(Point::new(slot_no.try_into()?, hex::decode(block_hash)?))
        .build();

    let mut follower =
        Follower::connect(&relay, Network::from_str(&network.clone())?, follower_cfg).await?;

    let genesis_values = network_genesis_values(&Network::from_str(&network.clone())?)
        .expect("Obtaining genesis values from follower crate is infallible");

    let task = tokio::spawn(async move {
        loop {
            let chain_update = match follower.next().await {
                Ok(chain_update) => chain_update,
                Err(err) => {
                    error!(
                        "Unable receive next update from follower {:?} - skip..",
                        err
                    );
                    continue;
                },
            };

            match chain_update {
                ChainUpdate::Block(data) => {
                    let block = match data.decode() {
                        Ok(block) => block,
                        Err(err) => {
                            error!("Unable to decode block {:?} - skip..", err);
                            continue;
                        },
                    };

                    match db
                        .updates_from_follower(
                            block.slot().try_into().expect("Slot conversion infallible"),
                            network.clone(),
                            block
                                .epoch(&genesis_values)
                                .0
                                .try_into()
                                .expect("Epoch conversion infallible"),
                            block
                                .wallclock(&genesis_values)
                                .try_into()
                                .expect("Wallclock conversion infallible"),
                            hex::encode(block.hash().clone()),
                        )
                        .await
                    {
                        Ok(_) => (),
                        Err(err) => {
                            error!("unable to index follower data {:?} - skip..", err);
                            continue;
                        },
                    }
                    // index the following

                    // utxo stuff

                    // registration stuff

                    // rewards stuff

                    // last updated
                    match db
                        .last_updated(
                            chrono::offset::Utc::now(),
                            block.slot().try_into().expect("Slot conversion infallible"),
                            hex::encode(block.hash().clone()),
                            network.clone(),
                        )
                        .await
                    {
                        Ok(_) => (),
                        Err(err) => {
                            error!("unable to mark last update point {:?} - skip..", err);
                            continue;
                        },
                    };
                },
                ChainUpdate::Rollback(data) => {
                    let block = match data.decode() {
                        Ok(block) => block,
                        Err(err) => {
                            error!("unable to decode block {:?} - skip..", err);
                            continue;
                        },
                    };

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

    Ok(task)
}
