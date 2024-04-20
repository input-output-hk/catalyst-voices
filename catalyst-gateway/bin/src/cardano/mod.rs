//! Logic for orchestrating followers
use std::{path::PathBuf, sync::Arc};

/// Handler for follower tasks, allows for control over spawned follower threads
pub type ManageTasks = JoinHandle<()>;

use cardano_chain_follower::{
    network_genesis_values, ChainUpdate, Follower, FollowerConfigBuilder, Network, Point,
};
use pallas::ledger::traverse::{wellknown::GenesisValues, MultiEraBlock};
use tokio::{task::JoinHandle, time};
use tracing::{debug, error, info};

use crate::{
    cardano::util::valid_era,
    event_db::{
        cardano::{config::FollowerConfig, chain_state::MachineId},
        error::NotFoundError,
        EventDB,
    },
};

pub(crate) mod cip36_registration;
pub(crate) mod util;

/// Returns a follower configs, waits until they present inside the db
async fn get_follower_config(check_config_tick: u64, db: Arc<EventDB>) -> Vec<FollowerConfig> {
    let mut interval = time::interval(time::Duration::from_secs(check_config_tick));
    loop {
        // tick until config exists
        interval.tick().await;

        match db.get_follower_config().await {
            Ok(config) => break config,
            Err(err) => error!("No follower config found, error: {err}"),
        }
    }
}

/// Start followers as per defined in the config
pub(crate) async fn start_followers(
    db: Arc<EventDB>, check_config_tick: u64, data_refresh_tick: u64, machine_id: String,
) -> anyhow::Result<()> {
    let mut current_config = get_follower_config(check_config_tick, db.clone()).await;
    loop {
        // spawn followers and obtain thread handlers for control and future cancellation
        let follower_tasks = spawn_followers(
            current_config.clone(),
            db.clone(),
            data_refresh_tick,
            machine_id.clone(),
        )
        .await?;

        // Followers should continue indexing until config has changed
        current_config = loop {
            let new_config = get_follower_config(check_config_tick, db.clone()).await;
            if new_config != current_config {
                info!("Config has changed! restarting");
                break new_config;
            }
        };

        // Config has changed, terminate all followers and restart with new config.
        info!("Terminating followers");
        for task in follower_tasks {
            task.abort();
        }
    }
}

/// Spawn follower threads and return associated handlers
async fn spawn_followers(
    configs: Vec<FollowerConfig>, db: Arc<EventDB>, _data_refresh_tick: u64, machine_id: String,
) -> anyhow::Result<Vec<ManageTasks>> {
    let mut follower_tasks = Vec::new();

    for config in &configs {
        let follower_handler = spawn_follower(
            config.network,
            &config.relay,
            db.clone(),
            machine_id.clone(),
            &config.mithril_snapshot.path,
        )
        .await?;

        follower_tasks.push(follower_handler);
    }

    Ok(follower_tasks)
}

/// Initiate single follower and returns associated task handler
/// which facilitates future control over spawned threads.
async fn spawn_follower(
    network: Network, relay: &str, db: Arc<EventDB>, machine_id: MachineId, snapshot: &str,
) -> anyhow::Result<ManageTasks> {
    // Establish point at which the last follower stopped updating in order to pick up
    // where it left off. If there was no previous follower, start indexing from
    // genesis point.
    let start_from = match db.last_updated_state(network).await {
        Ok((slot_no, block_hash, _)) => Point::new(slot_no.try_into()?, block_hash),
        Err(err) if err.is::<NotFoundError>() => Point::Origin,
        Err(err) => return Err(err),
    };

    info!("Starting {network:?} follower from {start_from:?}",);

    let mut follower = instantiate_follower(start_from, snapshot, network, relay).await?;

    let genesis_values = network_genesis_values(&network)
        .ok_or(anyhow::anyhow!("Obtaining genesis values failed"))?;

    let task = tokio::spawn(async move {
        process_blocks(&mut follower, db, network, machine_id, &genesis_values).await;
    });

    Ok(task)
}

/// Process next block from the follower
async fn process_blocks(
    follower: &mut Follower, db: Arc<EventDB>, network: Network, machine_id: MachineId,
    genesis_values: &GenesisValues,
) {
    loop {
        let chain_update = match follower.next().await {
            Ok(chain_update) => chain_update,
            Err(err) => {
                error!(
                    "Unable to receive next update from the {network:?} follower err: {err} - skip..",
                );
                continue;
            },
        };

        match chain_update {
            ChainUpdate::Block(data) => {
                let block = match data.decode() {
                    Ok(block) => block,
                    Err(err) => {
                        error!("Unable to decode {network:?} block {err} - skip..",);
                        continue;
                    },
                };
                let start_index_block = time::Instant::now();
                index_block(db.clone(), genesis_values, network, &machine_id, &block).await;
                debug!(
                    "{network:?} block {} indexing time: {}ns. txs amount: {}",
                    block.hash().to_string(),
                    start_index_block.elapsed().as_nanos(),
                    block.txs().len()
                );
            },
            ChainUpdate::Rollback(data) => {
                let block = match data.decode() {
                    Ok(block) => block,
                    Err(err) => {
                        error!("Unable to decode {network:?} block {err} - skip..");
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
}

/// Index block data, store it in our db
async fn index_block(
    db: Arc<EventDB>, genesis_values: &GenesisValues, network: Network, machine_id: &MachineId,
    block: &MultiEraBlock<'_>,
) {
    // Parse block
    let epoch = match block.epoch(genesis_values).0.try_into() {
        Ok(epoch) => epoch,
        Err(err) => {
            error!("Cannot parse epoch from {network:?} block {err} - skip..");
            return;
        },
    };

    let wallclock = match block.wallclock(genesis_values).try_into() {
        Ok(time) => chrono::DateTime::from_timestamp(time, 0).unwrap_or_default(),
        Err(err) => {
            error!("Cannot parse wall time from {network:?} block {err} - skip..");
            return;
        },
    };

    let slot = match block.slot().try_into() {
        Ok(slot) => slot,
        Err(err) => {
            error!("Cannot parse slot from {network:?} block {err} - skip..");
            return;
        },
    };

    let start_index_follower_data = time::Instant::now();
    match db
        .index_follower_data(slot, network, epoch, wallclock, block.hash().to_vec())
        .await
    {
        Ok(()) => (),
        Err(err) => {
            error!("Unable to index {network:?} follower data {err} - skip..");
            return;
        },
    }
    debug!(
        "{network:?} follower data indexing time: {}ns",
        start_index_follower_data.elapsed().as_nanos()
    );

    for tx in block.txs() {
        // index tx
        let start_index_txn_data = time::Instant::now();
        match db.index_txn_data(tx.hash().as_slice(), slot, network).await {
            Ok(()) => (),
            Err(err) => {
                error!("Unable to index {network:?} txn data {err} - skip..");
                continue;
            },
        }
        debug!(
            "{network:?} tx {} data indexing time: {}ns",
            tx.hash().to_string(),
            start_index_txn_data.elapsed().as_nanos()
        );

        // index utxo
        let start_index_utxo_data = time::Instant::now();
        match db.index_utxo_data(&tx).await {
            Ok(()) => (),
            Err(err) => {
                error!("Unable to index {network:?} utxo data for tx {err} - skip..");
                continue;
            },
        }
        debug!(
            "{network:?} tx {} utxo data indexing time: {}ns",
            tx.hash().to_string(),
            start_index_utxo_data.elapsed().as_nanos()
        );

        // Block processing for Eras before staking are ignored.
        if valid_era(block.era()) {
            // index catalyst registrations
            let start_index_registration_data = time::Instant::now();
            match db.index_registration_data(&tx, network).await {
                Ok(()) => (),
                Err(err) => {
                    error!("Unable to index {network:?} registration data for tx {err} - skip..",);
                    continue;
                },
            }
            debug!(
                "{network:?} tx {} registration data indexing time: {}ns",
                tx.hash().to_string(),
                start_index_registration_data.elapsed().as_nanos()
            );

            // Rewards
        }
    }

    // Refresh update metadata for future followers
    match db
        .refresh_last_updated(
            chrono::offset::Utc::now(),
            slot,
            block.hash().to_vec(),
            network,
            machine_id,
        )
        .await
    {
        Ok(()) => {},
        Err(err) => {
            error!("Unable to mark {network:?} last update point {err} - skip..",);
        },
    };
}

/// Instantiate the follower.
/// If there is metadata present which allows us to bootstrap from a point in time
/// We start from there, if not; we start from genesis.
async fn instantiate_follower(
    start_from: Point, snapshot: &str, network: Network, relay: &str,
) -> anyhow::Result<Follower> {
    let mut follower_cfg = FollowerConfigBuilder::default()
        .follow_from(start_from)
        .mithril_snapshot_path(PathBuf::from(snapshot))
        .build();

    let follower = match Follower::connect(relay, network, follower_cfg.clone()).await {
        Ok(follower) => follower,
        Err(err) => {
            error!("Unable to bootstrap via mithril snapshot {err}. Trying network..",);

            // We know bootstrapping from the snapshot fails, remove path and try from network
            follower_cfg.mithril_snapshot_path = None;
            Follower::connect(relay, network, follower_cfg).await?
        },
    };

    Ok(follower)
}
