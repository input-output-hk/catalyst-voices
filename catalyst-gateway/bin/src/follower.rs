//! Logic for orchestrating followers
use std::{path::PathBuf, sync::Arc};

/// Handler for follower tasks, allows for control over spawned follower threads
pub type ManageTasks = JoinHandle<()>;

use async_recursion::async_recursion;
use cardano_chain_follower::{
    network_genesis_values, ChainUpdate, Follower, FollowerConfigBuilder, Network, Point,
};
use chrono::TimeZone;
use tokio::{task::JoinHandle, time};
use tracing::{error, info};

use crate::{
    event_db::{
        config::FollowerConfig,
        follower::{BlockHash, BlockTime, MachineId, SlotNumber},
        EventDB,
    },
    util::valid_era,
};

/// Arbritrary value which is only used in the case where there is no
/// previous followers making the question of data staleness irrelevant.
const DATA_NOT_STALE: i64 = 1;

#[async_recursion]
/// Start followers as per defined in the config
pub(crate) async fn start_followers(
    configs: Vec<FollowerConfig>, db: Arc<EventDB>, data_refresh_tick: u64, check_config_tick: u64,
    machine_id: String,
) -> anyhow::Result<()> {
    // spawn followers and obtain thread handlers for control and future cancellation
    let follower_tasks = spawn_followers(
        configs.clone(),
        db.clone(),
        data_refresh_tick,
        machine_id.clone(),
    )
    .await?;

    // Followers should continue indexing until config has changed
    let mut interval = time::interval(time::Duration::from_secs(check_config_tick));
    let config = loop {
        interval.tick().await;
        match db.get_follower_config().await {
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
        task.abort();
    }

    match config {
        Some(config) => {
            info!("Restarting followers with new config");
            start_followers(
                config,
                db,
                data_refresh_tick,
                check_config_tick,
                machine_id.clone(),
            )
            .await?;
        },
        None => return Err(anyhow::anyhow!("Config has been deleted...")),
    }

    Ok(())
}

/// Spawn follower threads and return associated handlers
async fn spawn_followers(
    configs: Vec<FollowerConfig>, db: Arc<EventDB>, data_refresh_tick: u64, machine_id: String,
) -> anyhow::Result<Vec<ManageTasks>> {
    let mut follower_tasks = Vec::new();

    for config in &configs {
        info!("starting follower for {:?}", config.network);

        // Tick until data is stale then start followers
        let mut interval = time::interval(time::Duration::from_secs(data_refresh_tick));
        let task_handler = loop {
            interval.tick().await;

            // Check if previous follower has indexed, if so, return last update point in order to
            // continue indexing from that point. If there was no previous follower, we
            // start from genesis point.
            let (slot_no, block_hash, last_updated) =
                find_last_update_point(db.clone(), config.network).await?;

            // Data is marked as stale after N seconds with no updates.
            let threshold = if let Some(last_update) = last_updated {
                last_update.timestamp()
            } else {
                info!(
                    "No previous followers, staleness not relevant. Start follower from genesis."
                );
                DATA_NOT_STALE
            };

            // Threshold which defines if data is stale and ready to update or not
            if chrono::offset::Utc::now().timestamp() - threshold
                > config.mithril_snapshot.timing_pattern.into()
            {
                info!(
                    "Last update is stale for network {:?} - ready to update, starting follower now.",
                    config.network
                );
                let follower_handler = init_follower(
                    config.network,
                    &config.relay,
                    (slot_no, block_hash),
                    db.clone(),
                    machine_id.clone(),
                    &config.mithril_snapshot.path,
                )
                .await?;
                break follower_handler;
            }
            info!(
                "Data is still fresh for network {:?}, tick until data is stale",
                config.network
            );
        };

        follower_tasks.push(task_handler);
    }

    Ok(follower_tasks)
}

/// Establish point at which the last follower stopped updating in order to pick up where
/// it left off. If there was no previous follower, start indexing from genesis point.
async fn find_last_update_point(
    db: Arc<EventDB>, network: Network,
) -> anyhow::Result<(Option<SlotNumber>, Option<BlockHash>, Option<BlockTime>)> {
    let (slot_no, block_hash, last_updated) = match db.last_updated_metadata(network).await {
        Ok((slot_no, block_hash, last_updated)) => {
            info!(
                "Previous follower stopped updating at Slot_no: {} block_hash:{} last_updated: {}",
                slot_no, block_hash, last_updated
            );
            (Some(slot_no), Some(block_hash), Some(last_updated))
        },
        Err(err) => {
            info!("No previous followers, start from genesis. Db msg: {}", err);
            (None, None, None)
        },
    };

    Ok((slot_no, block_hash, last_updated))
}

/// Initiate single follower and returns associated task handler
/// which facilitates future control over spawned threads.
#[allow(clippy::too_many_lines)] // we will refactor later
async fn init_follower(
    network: Network, relay: &str, start_from: (Option<SlotNumber>, Option<BlockHash>),
    db: Arc<EventDB>, machine_id: MachineId, snapshot: &str,
) -> anyhow::Result<ManageTasks> {
    let mut follower = follower_connection(start_from, snapshot, network, relay).await?;

    let genesis_values = network_genesis_values(&network)
        .ok_or(anyhow::anyhow!("Obtaining genesis values failed"))?;

    let task = tokio::spawn(async move {
        loop {
            let chain_update = match follower.next().await {
                Ok(chain_update) => chain_update,
                Err(err) => {
                    error!(
                        "Unable to receive next update from the follower {:?} - skip..",
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
                        Ok(time) => chrono::Utc.timestamp_nanos(time),
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
                            network,
                            epoch,
                            wallclock,
                            hex::encode(block.hash()),
                        )
                        .await
                    {
                        Ok(()) => (),
                        Err(err) => {
                            error!("Unable to index follower data {:?} - skip..", err);
                            continue;
                        },
                    }

                    // index utxo
                    match db.index_utxo_data(block.txs(), slot, network).await {
                        Ok(()) => (),
                        Err(err) => {
                            error!("Unable to index utxo data for block {:?} - skip..", err);
                            continue;
                        },
                    }

                    // Block processing for Eras before staking are ignored.
                    if valid_era(block.era()) {

                        // Registration
                        match db.index_registration_data(block.txs(), slot, network).await {
                            Ok(()) => (),
                            Err(err) => {
                                error!(
                                    "Unable to index registration data for block {:?} - skip..",
                                    err
                                );
                                continue;
                            },
                        }

                        // Rewards
                    }

                    // Refresh update metadata for future followers
                    match db
                        .refresh_last_updated(
                            chrono::offset::Utc::now(),
                            slot,
                            hex::encode(block.hash()),
                            network,
                            &machine_id,
                        )
                        .await
                    {
                        Ok(()) => (),
                        Err(err) => {
                            error!("Unable to mark last update point {:?} - skip..", err);
                            continue;
                        },
                    };
                },
                ChainUpdate::Rollback(data) => {
                    let block = match data.decode() {
                        Ok(block) => block,
                        Err(err) => {
                            error!("Unable to decode block {:?} - skip..", err);
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

/// In the context of setting up the follower connection.
/// If there is metadata present which allows us to bootstrap from a point in time
/// We start from there, if not; we start from genesis.
async fn follower_connection(
    start_from: (Option<SlotNumber>, Option<BlockHash>), snapshot: &str, network: Network,
    relay: &str,
) -> anyhow::Result<Follower> {
    let mut follower_cfg = if start_from.0.is_none() || start_from.1.is_none() {
        // start from genesis, no previous followers, hence no starting points.
        FollowerConfigBuilder::default()
            .follow_from(Point::Origin)
            .mithril_snapshot_path(PathBuf::from(snapshot))
            .build()
    } else {
        // start from given point
        FollowerConfigBuilder::default()
            .follow_from(Point::new(
                start_from
                    .0
                    .ok_or(anyhow::anyhow!("Slot number not present"))?
                    .try_into()?,
                hex::decode(
                    start_from
                        .1
                        .ok_or(anyhow::anyhow!("Block Hash not present"))?,
                )?,
            ))
            .mithril_snapshot_path(PathBuf::from(snapshot))
            .build()
    };

    let follower = match Follower::connect(relay, network, follower_cfg.clone()).await {
        Ok(follower) => follower,
        Err(err) => {
            error!(
                "Unable to bootstrap via mithril snapshot {}. Trying network..",
                err
            );

            // We know bootstrapping from the snapshot fails, remove path and try from network
            follower_cfg.mithril_snapshot_path = None;
            Follower::connect(relay, network, follower_cfg).await?
        },
    };

    Ok(follower)
}
