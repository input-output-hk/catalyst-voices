use std::{error::Error, str::FromStr, sync::Arc};

use async_recursion::async_recursion;
use cardano_chain_follower::{
    network_genesis_values, ChainUpdate, Follower, FollowerConfigBuilder, Network, Point,
};
use tokio::time;
use tracing::{error, info};

use crate::event_db::{
    legacy::queries::event::{
        config::{ConfigQueries, FollowerMeta, NetworkMeta},
        follower::FollowerQueries,
    },
    EventDB,
};

#[async_recursion]
/// Start followers as per defined in the config
pub(crate) async fn start_followers(
    configs: (Vec<NetworkMeta>, FollowerMeta), db: Arc<EventDB>, data_refresh_tick: u64,
    check_config_tick: u64,
) -> Result<(), Box<dyn Error>> {
    let mut follower_tasks = Vec::new();

    for config in &configs.0 {
        info!("starting follower for {:?}", config.network);

        // Tick until data is stale then start followers
        let mut interval = time::interval(time::Duration::from_secs(data_refresh_tick));
        let task_handler = loop {
            interval.tick().await;
            // We need to find at which point the last follower stopped updating in order to pick up
            // where it left off.
            let (slot_no, block_hash, last_updated) =
                db.last_updated_metadata(config.network.clone()).await?;

            // Threshold which defines if data is stale and ready to update or not
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

    // Continue indexing until config has changed
    let mut interval = time::interval(time::Duration::from_secs(check_config_tick));
    let config = loop {
        interval.tick().await;
        match db.get_config().await.map(|config| config) {
            Ok(config) => {
                if configs != config {
                    info!("Config has changed! restarting");
                    break Some(config);
                }
            },
            Err(err) => {
                error!("No config {:?}", err);
                break None;
            },
        }
    };

    // Config has changed, terminate all followers and restart with new config.
    info!("Terminating followers");
    for task in follower_tasks {
        task.abort()
    }

    match config {
        Some(config) => {
            info!("Restarting followers with new config");
            start_followers(config, db, data_refresh_tick, check_config_tick).await?;
        },
        None => return Err("Config has been deleted...".into()),
    }

    Ok(())
}

/// Initiate single follower and return task handler
async fn init_follower(
    network: String, relay: String, slot_no: i64, block_hash: String, db: Arc<EventDB>,
) -> Result<tokio::task::JoinHandle<()>, Box<dyn Error>> {
    let follower_cfg = FollowerConfigBuilder::default()
        .follow_from(Point::new(slot_no.try_into()?, hex::decode(block_hash)?))
        .build();

    let mut follower =
        Follower::connect(&relay, Network::from_str(&network.clone())?, follower_cfg).await?;

    let genesis_values = network_genesis_values(&Network::from_str(&network.clone())?)
        .ok_or("Obtaining genesis values should be infallible")?;

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

                    // Parse block

                    let epoch = match block.epoch(&genesis_values).0.try_into() {
                        Ok(epoch) => epoch,
                        Err(err) => {
                            error!("Cannot parse epoch from block {:?} - skip..", err);
                            continue;
                        },
                    };

                    let wallclock = match block.wallclock(&genesis_values).try_into() {
                        Ok(time) => time,
                        Err(err) => {
                            error!("Cannot parse wall time from block {:?} - skip..", err);
                            continue;
                        },
                    };

                    let slot = match block.slot().try_into() {
                        Ok(slot) => slot,
                        Err(err) => {
                            error!("Cannot parse slot from block {:?} - skip..", err);
                            continue;
                        },
                    };

                    match db
                        .index_follower_data(
                            slot,
                            network.clone(),
                            epoch,
                            wallclock,
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

                    // TODO

                    // Index the following:

                    // Utxo stuff

                    // Registration stuff

                    // Rewards stuff

                    // Last updated

                    // Refresh update metadata for future followers
                    match db
                        .refresh_last_updated(
                            chrono::offset::Utc::now(),
                            slot,
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
