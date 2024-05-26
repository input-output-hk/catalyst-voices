//! Logic for orchestrating followers
use std::{path::PathBuf, sync::Arc, time::Duration};

/// Handler for follower tasks, allows for control over spawned follower threads
pub type ManageTasks = JoinHandle<()>;

use cardano_chain_follower::{
    network_genesis_values, ChainUpdate, Follower, FollowerConfigBuilder, Network, Point,
};
use pallas::ledger::traverse::{wellknown::GenesisValues, MultiEraBlock, MultiEraTx};
use tokio::{sync::mpsc, task::JoinHandle, time};
use tracing::{error, info};

use crate::event_db::{
    cardano::{
        chain_state::{IndexedFollowerDataParams, MachineId},
        cip36_registration::IndexedVoterRegistrationParams,
        config::FollowerConfig,
        utxo::{IndexedTxnInputParams, IndexedTxnOutputParams, IndexedTxnParams},
    },
    error::NotFoundError,
    EventDB,
};

pub(crate) mod cip36_registration;
pub(crate) mod util;

/// Blocks batch length that will trigger the blocks buffer to be written to the database.
const MAX_BLOCKS_BATCH_LEN: usize = 1024;

/// Returns a follower configs, waits until they present inside the db
async fn get_follower_config(
    check_config_tick: u64, db: Arc<EventDB>,
) -> anyhow::Result<Vec<FollowerConfig>> {
    let mut interval = time::interval(time::Duration::from_secs(check_config_tick));
    loop {
        // tick until config exists
        interval.tick().await;

        match db.get_follower_config().await {
            Ok(configs) => break Ok(configs),
            Err(err) if err.is::<NotFoundError>() => {
                error!("No follower config found");
                continue;
            },
            Err(err) => break Err(err),
        }
    }
}

/// Start followers as per defined in the config
pub(crate) async fn start_followers(
    db: Arc<EventDB>, check_config_tick: u64, data_refresh_tick: u64, machine_id: String,
) -> anyhow::Result<()> {
    let mut current_config = get_follower_config(check_config_tick, db.clone()).await?;
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
            let new_config = get_follower_config(check_config_tick, db.clone()).await?;
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
    info!("Follower started processing blocks");

    let (blocks_tx, mut blocks_rx) = mpsc::channel(1);

    tokio::spawn({
        let genesis_values = genesis_values.clone();

        async move {
            let mut blocks_buffer = Vec::new();

            let mut ticker = tokio::time::interval(Duration::from_secs(60));
            ticker.set_missed_tick_behavior(tokio::time::MissedTickBehavior::Delay);

            loop {
                tokio::select! {
                    res = blocks_rx.recv() => {
                        match res {
                            Some(block_data) => {
                                blocks_buffer.push(block_data);

                                if blocks_buffer.len() >= MAX_BLOCKS_BATCH_LEN {
                                    index_block_buffer(db.clone(), &genesis_values, network, &machine_id, std::mem::take(&mut blocks_buffer)).await;

                                    // Reset batch ticker since we just indexed the blocks buffer
                                    ticker.reset();
                                }
                            }

                            None => {
                                break;
                            }
                        }
                    }

                    _ = ticker.tick() => {
                        // This executes when we have not indexed blocks for more than the configured
                        // tick interval. This means that if any errors occur in that time we lose the buffered block data (e.g.
                        // cat-gateway is shutdown ungracefully). This is not a problem since cat-gateway
                        // checkpoints the latest database writes so it simply restarts from the last
                        // written block.
                        //
                        // This is most likely to happen when following from the tip or receiving blocks
                        // from the network (since updates will come at larger intervals).
                        if blocks_buffer.is_empty() {
                            continue;
                        }

                        let current_buffer = std::mem::take(&mut blocks_buffer);
                        index_block_buffer(db.clone(), &genesis_values, network, &machine_id, current_buffer).await;

                        // Reset the ticker so it counts the interval as starting after we wrote everything
                        // to the database.
                        ticker.reset();
                    }
                }
            }
        }
    });

    loop {
        match follower.next().await {
            Ok(chain_update) => match chain_update {
                ChainUpdate::Block(data) => {
                    if blocks_tx.send(data).await.is_err() {
                        error!("Block indexing task not running");
                        break;
                    };
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
            },
            Err(err) => {
                error!(
                        "Unable to receive next update from the {network:?} follower err: {err} - skip..",
                    );
                continue;
            },
        }
    }
}

/// Consumes a block buffer and indexes its data.
async fn index_block_buffer(
    db: Arc<EventDB>, genesis_values: &GenesisValues, network: Network, machine_id: &MachineId,
    buffer: Vec<cardano_chain_follower::MultiEraBlockData>,
) {
    info!("Starting data indexing");

    let mut blocks = Vec::new();

    for block_data in &buffer {
        match block_data.decode() {
            Ok(block) => blocks.push(block),
            Err(e) => {
                error!(error = ?e, "Failed to decode block");
            },
        }
    }

    index_many_blocks(db.clone(), genesis_values, network, machine_id, &blocks).await;
}

/// Index a slice of blocks.
async fn index_many_blocks(
    db: Arc<EventDB>, genesis_values: &GenesisValues, network: Network, machine_id: &MachineId,
    blocks: &[MultiEraBlock<'_>],
) {
    let Some(last_block) = blocks.last() else {
        return;
    };

    let network_str = network.to_string();

    if !index_blocks(&db, genesis_values, &network_str, blocks).await {
        return;
    }

    if !index_transactions(&db, blocks, &network_str).await {
        return;
    }

    if !index_voter_registrations(&db, blocks, network).await {
        return;
    }

    // SAFETY: This is safe to ignore because we would not reach this point if
    // the try_into inside the block indexing loop had failed.
    #[allow(clippy::cast_possible_wrap)]
    match db
        .refresh_last_updated(
            chrono::offset::Utc::now(),
            last_block.slot() as i64,
            last_block.hash().to_vec(),
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

/// Index the data from the given blocks.
async fn index_blocks(
    db: &EventDB, genesis_values: &GenesisValues, network_str: &str, blocks: &[MultiEraBlock<'_>],
) -> bool {
    let values: Vec<_> = blocks
        .iter()
        .filter_map(|block| {
            IndexedFollowerDataParams::from_block_data(genesis_values, network_str, block)
        })
        .collect();

    match db.index_many_follower_data(&values).await {
        Ok(()) => {
            info!(count = values.len(), "Finished indexing block data");
            true
        },
        Err(e) => {
            error!(error = ?e, "Failed to write DB entries");
            false
        },
    }
}

/// Index transactions (and its inputs and outputs) from a slice of blocks.
async fn index_transactions(db: &EventDB, blocks: &[MultiEraBlock<'_>], network_str: &str) -> bool {
    let blocks_txs: Vec<_> = blocks
        .iter()
        .flat_map(|b| b.txs().into_iter().map(|tx| (b.slot(), tx)))
        .collect();

    if !index_transactions_data(db, network_str, &blocks_txs).await {
        return false;
    }

    if !index_transaction_outputs_data(db, &blocks_txs).await {
        return false;
    }

    if !index_transaction_inputs_data(db, &blocks_txs).await {
        return false;
    }

    true
}

/// Index transactions data.
async fn index_transactions_data(
    db: &EventDB, network_str: &str, blocks_txs: &[(u64, MultiEraTx<'_>)],
) -> bool {
    let values: Vec<_> = blocks_txs
        .iter()
        .map(|(slot, tx)| {
            // SAFETY: This is safe to ignore because we would not reach this point if
            // the try_into inside the block indexing loop had failed.
            #[allow(clippy::cast_possible_wrap)]
            IndexedTxnParams {
                id: tx.hash().to_vec(),
                slot_no: *slot as i64,
                network: network_str,
            }
        })
        .collect();

    match db.index_many_txn_data(&values).await {
        Ok(()) => info!(count = values.len(), "Finished indexing transactions"),
        Err(e) => {
            error!(error = ?e, "Failed to index transactions");
            return false;
        },
    }

    true
}

/// Index transaction outputs data.
async fn index_transaction_outputs_data(
    db: &EventDB, blocks_txs: &[(u64, MultiEraTx<'_>)],
) -> bool {
    let values: Vec<_> = blocks_txs
        .iter()
        .flat_map(|(_, tx)| IndexedTxnOutputParams::from_txn_data(tx))
        .collect();

    match db.index_many_txn_output_data(&values).await {
        Ok(()) => {
            info!(
                count = values.len(),
                "Finished indexing transaction outputs data"
            );
            true
        },
        Err(e) => {
            error!(error = ?e, "Failed to index transaction outputs data");
            false
        },
    }
}

/// Index transaction inputs data.
async fn index_transaction_inputs_data(db: &EventDB, blocks_txs: &[(u64, MultiEraTx<'_>)]) -> bool {
    let values: Vec<_> = blocks_txs
        .iter()
        .flat_map(|(_, tx)| IndexedTxnInputParams::from_txn_data(tx))
        .collect();

    match db.index_many_txn_input_data(&values).await {
        Ok(()) => {
            info!(
                count = values.len(),
                "Finished indexing transaction inputs data"
            );
            true
        },
        Err(e) => {
            error!(error = ?e, "Failed to index transaction inputs data");
            false
        },
    }
}

/// Index voter registrations from a slice of blocks.
async fn index_voter_registrations(
    db: &EventDB, blocks: &[MultiEraBlock<'_>], network: Network,
) -> bool {
    let values: Vec<_> = blocks
        .iter()
        .filter_map(|block| IndexedVoterRegistrationParams::from_block_data(block, network))
        .flatten()
        .collect();

    match db.index_many_voter_registration_data(&values).await {
        Ok(()) => {
            info!(
                count = values.len(),
                "Finished indexing voter registrations data"
            );
            true
        },
        Err(e) => {
            error!(error = ?e, "Failed to index voter registrations data");
            false
        },
    }
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
