//! Logic for orchestrating followers

use std::{fmt::Display, sync::Arc, time::Duration};

use cardano_chain_follower::{
    ChainFollower, ChainSyncConfig, Network, Point, ORIGIN_POINT, TIP_POINT,
};
use duration_string::DurationString;
use futures::{stream::FuturesUnordered, StreamExt};
use rand::{Rng, SeedableRng};
use tracing::{debug, error, info, warn};

use crate::{
    db::index::{
        block::index_block,
        queries::sync_status::{get::get_sync_status, update::update_sync_status},
        session::CassandraSession,
    },
    settings::{chain_follower, Settings},
};

// pub(crate) mod cip36_registration_obsolete;
pub(crate) mod util;

/// Blocks batch length that will trigger the blocks buffer to be written to the database.
#[allow(dead_code)]
const MAX_BLOCKS_BATCH_LEN: usize = 1024;

/// How long we wait between checks for connection to the indexing DB to be ready.
const INDEXING_DB_READY_WAIT_INTERVAL: Duration = Duration::from_secs(1);

/// Start syncing a particular network
async fn start_sync_for(cfg: &chain_follower::EnvVars) -> anyhow::Result<()> {
    let chain = cfg.chain;
    let dl_config = cfg.dl_config.clone();

    let mut cfg = ChainSyncConfig::default_for(chain);
    cfg.mithril_cfg = cfg.mithril_cfg.with_dl_config(dl_config);
    info!(chain = %chain, "Starting Blockchain Sync");

    if let Err(error) = cfg.run().await {
        error!(chain=%chain, error=%error, "Failed to start chain sync task");
        Err(error)?;
    }

    Ok(())
}

/// Data we return from a sync task.
#[derive(Clone)]
struct SyncParams {
    /// What blockchain are we syncing.
    chain: Network,
    /// The starting point of this sync.
    start: Point,
    /// The ending point of this sync.
    end: Point,
    /// The first block we successfully synced.
    first_indexed_block: Option<Point>,
    /// Is the starting point immutable? (True = immutable, false = don't know.)
    first_is_immutable: bool,
    /// The last block we successfully synced.
    last_indexed_block: Option<Point>,
    /// Is the ending point immutable? (True = immutable, false = don't know.)
    last_is_immutable: bool,
    /// The number of blocks we successfully synced overall.
    total_blocks_synced: u64,
    /// The number of blocks we successfully synced, in the last attempt.
    last_blocks_synced: u64,
    /// The number of retries so far on this sync task.
    retries: u64,
    /// The number of retries so far on this sync task.
    backoff_delay: Option<Duration>,
    /// If the sync completed without error or not.
    result: Arc<Option<anyhow::Result<()>>>,
}

impl Display for SyncParams {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        if self.result.is_none() {
            write!(f, "Sync_Params {{ ")?;
        } else {
            write!(f, "Sync_Result {{ ")?;
        }

        write!(f, "start: {}, end: {}", self.start, self.end)?;

        if let Some(first) = self.first_indexed_block.as_ref() {
            write!(
                f,
                ", first_indexed_block: {first}{}",
                if self.first_is_immutable { ":I" } else { "" }
            )?;
        }

        if let Some(last) = self.last_indexed_block.as_ref() {
            write!(
                f,
                ", last_indexed_block: {last}{}",
                if self.last_is_immutable { ":I" } else { "" }
            )?;
        }

        if self.retries > 0 {
            write!(f, ", retries: {}", self.retries)?;
        }

        if self.retries > 0 || self.result.is_some() {
            write!(f, ", synced_blocks: {}", self.total_blocks_synced)?;
        }

        if self.result.is_some() {
            write!(f, ", last_sync: {}", self.last_blocks_synced)?;
        }

        if let Some(backoff) = self.backoff_delay.as_ref() {
            write!(f, ", backoff: {}", DurationString::from(*backoff))?;
        }

        if let Some(result) = self.result.as_ref() {
            match result {
                Ok(()) => write!(f, ", Success")?,
                Err(error) => write!(f, ", {error}")?,
            };
        }

        f.write_str(" }")
    }
}

/// The range we generate random backoffs within given a base backoff value.
const BACKOFF_RANGE_MULTIPLIER: u32 = 3;

impl SyncParams {
    /// Create a new `SyncParams`.
    fn new(chain: Network, start: Point, end: Point) -> Self {
        Self {
            chain,
            start,
            end,
            first_indexed_block: None,
            first_is_immutable: false,
            last_indexed_block: None,
            last_is_immutable: false,
            total_blocks_synced: 0,
            last_blocks_synced: 0,
            retries: 0,
            backoff_delay: None,
            result: Arc::new(None),
        }
    }

    /// Convert a result back into parameters for a retry.
    fn retry(&self) -> Self {
        let retry_count = self.retries + 1;

        let mut backoff = None;

        // If we did sync any blocks last time, first retry is immediate.
        // Otherwise we backoff progressively more as we do more retries.
        if self.last_blocks_synced == 0 {
            // Calculate backoff based on number of retries so far.
            backoff = match retry_count {
                1 => Some(Duration::from_secs(1)),     // 1-3 seconds
                2..5 => Some(Duration::from_secs(10)), // 10-30 seconds
                _ => Some(Duration::from_secs(30)),    // 30-90 seconds.
            };
        }

        let mut retry = self.clone();
        retry.last_blocks_synced = 0;
        retry.retries = retry_count;
        retry.backoff_delay = backoff;
        retry.result = Arc::new(None);

        retry
    }

    /// Convert Params into the result of the sync.
    fn done(
        &self, first: Option<Point>, first_immutable: bool, last: Option<Point>,
        last_immutable: bool, synced: u64, result: anyhow::Result<()>,
    ) -> Self {
        if result.is_ok() && first_immutable && last_immutable {
            // Update sync status in the Immutable DB.
            // Can fire and forget, because failure to update DB will simply cause the chunk to be
            // re-indexed, on recovery.
            update_sync_status(self.end.slot_or_default(), self.start.slot_or_default());
        }

        let mut done = self.clone();
        done.first_indexed_block = first;
        done.first_is_immutable = first_immutable;
        done.last_indexed_block = last;
        done.last_is_immutable = last_immutable;
        done.total_blocks_synced += synced;
        done.last_blocks_synced = synced;

        done.result = Arc::new(Some(result));

        done
    }

    /// Get where this sync run actually needs to start from.
    fn actual_start(&self) -> Point {
        self.last_indexed_block
            .as_ref()
            .unwrap_or(&self.start)
            .clone()
    }

    /// Do the backoff delay processing.
    ///
    /// The actual delay is a random time from the Delay itself to
    /// `BACKOFF_RANGE_MULTIPLIER` times the delay. This is to prevent hammering the
    /// service at regular intervals.
    async fn backoff(&self) {
        if let Some(backoff) = self.backoff_delay {
            let mut rng = rand::rngs::StdRng::from_entropy();
            let actual_backoff =
                rng.gen_range(backoff..backoff.saturating_mul(BACKOFF_RANGE_MULTIPLIER));

            tokio::time::sleep(actual_backoff).await;
        }
    }
}

/// Sync a portion of the blockchain.
/// Set end to `TIP_POINT` to sync the tip continuously.
fn sync_subchain(params: SyncParams) -> tokio::task::JoinHandle<SyncParams> {
    tokio::spawn(async move {
        info!(chain = %params.chain, params=%params, "Indexing Blockchain");

        // Backoff hitting the database if we need to.
        params.backoff().await;

        // Wait for indexing DB to be ready before continuing.
        CassandraSession::wait_is_ready(INDEXING_DB_READY_WAIT_INTERVAL).await;
        info!(chain=%params.chain, params=%params,"Indexing DB is ready");

        let mut first_indexed_block = params.first_indexed_block.clone();
        let mut first_immutable = params.first_is_immutable;
        let mut last_indexed_block = params.last_indexed_block.clone();
        let mut last_immutable = params.last_is_immutable;
        let mut blocks_synced = 0u64;

        let mut follower =
            ChainFollower::new(params.chain, params.actual_start(), params.end.clone()).await;
        while let Some(chain_update) = follower.next().await {
            match chain_update.kind {
                cardano_chain_follower::Kind::ImmutableBlockRollForward => {
                    // We only process these on the follower tracking the TIP.
                    if params.end == TIP_POINT {
                        warn!("TODO: Immutable Chain roll forward");
                    };
                },
                cardano_chain_follower::Kind::Block => {
                    let block = chain_update.block_data();

                    if let Err(error) = index_block(block).await {
                        let error_msg = format!("Failed to index block {}", block.point());
                        error!(chain=%params.chain, error=%error, params=%params, error_msg);
                        return params.done(
                            first_indexed_block,
                            first_immutable,
                            last_indexed_block,
                            last_immutable,
                            blocks_synced,
                            Err(error.context(error_msg)),
                        );
                    }

                    last_immutable = block.immutable();
                    last_indexed_block = Some(block.point());

                    if first_indexed_block.is_none() {
                        first_immutable = last_immutable;
                        first_indexed_block = Some(block.point());
                    }
                    blocks_synced += 1;
                },
                cardano_chain_follower::Kind::Rollback => {
                    warn!("TODO: Live Chain rollback");
                },
            }
        }

        let result = params.done(
            first_indexed_block,
            first_immutable,
            last_indexed_block,
            last_immutable,
            blocks_synced,
            Ok(()),
        );

        info!(chain = %params.chain, result=%result, "Indexing Blockchain Completed: OK");

        result
    })
}

/// Start followers as per defined in the config
#[allow(unused)]
pub(crate) async fn start_followers() -> anyhow::Result<()> {
    let cfg = Settings::follower_cfg();

    // Log the chain follower configuration.
    cfg.log();

    // Start Syncing the blockchain, so we can consume its data as required.
    start_sync_for(&cfg).await?;
    info!(chain=%cfg.chain,"Chain Sync is started.");

    tokio::spawn(async move {
        // We can't sync until the local chain data is synced.
        // This call will wait until we sync.
        let tips = cardano_chain_follower::ChainFollower::get_tips(cfg.chain).await;
        let immutable_tip_slot = tips.0.slot_or_default();
        let live_tip_slot = tips.1.slot_or_default();
        info!(chain=%cfg.chain, immutable_tip=immutable_tip_slot, live_tip=live_tip_slot, "Blockchain ready to sync from.");

        // Wait for indexing DB to be ready before continuing.
        // We do this after the above, because other nodes may have finished already, and we don't
        // want to wait do any work they already completed while we were fetching the blockchain.
        CassandraSession::wait_is_ready(INDEXING_DB_READY_WAIT_INTERVAL).await;
        info!(chain=%cfg.chain, "Indexing DB is ready - Getting recovery state");
        let sync_status = get_sync_status().await;
        debug!(chain=%cfg.chain, "Sync Status: {:?}", sync_status);

        let mut sync_tasks: FuturesUnordered<tokio::task::JoinHandle<SyncParams>> =
            FuturesUnordered::new();

        // Start the Immutable Chain sync tasks.
        // If the number of sync tasks is zero, just have one.
        //   Note: this shouldn't be possible, but easy to handle if it is.
        let sub_chain_slots = immutable_tip_slot
            .checked_div(cfg.sync_tasks.into())
            .unwrap_or(immutable_tip_slot);
        // Need steps in a usize, in the highly unlikely event the steps are > max usize, make
        // them max usize.
        let sub_chain_steps: usize = sub_chain_slots.try_into().unwrap_or(usize::MAX);

        let mut start_point = ORIGIN_POINT;
        for slot_end in (sub_chain_slots..immutable_tip_slot).step_by(sub_chain_steps) {
            let next_point = cardano_chain_follower::Point::fuzzy(slot_end);

            sync_tasks.push(sync_subchain(SyncParams::new(
                cfg.chain,
                start_point,
                next_point.clone(),
            )));

            // Next start == last end.
            start_point = next_point;
        }

        // Start the Live Chain sync task - This never stops syncing.
        sync_tasks.push(sync_subchain(SyncParams::new(
            cfg.chain,
            start_point,
            TIP_POINT,
        )));

        // Wait Sync tasks to complete.  If they fail and have not completed, reschedule them.
        // They will return from this iterator in the order they complete.
        while let Some(completed) = sync_tasks.next().await {
            let remaining_followers = sync_tasks.len();

            match completed {
                Ok(finished) => {
                    // Sync task finished.  Check if it completed OK or had an error.
                    // If it failed, we need to reschedule it.

                    let last_block = finished
                        .last_indexed_block
                        .clone()
                        .map_or("None".to_string(), |v| v.to_string());

                    let first_block = finished
                        .first_indexed_block
                        .clone()
                        .map_or("None".to_string(), |v| v.to_string());

                    // The TIP follower should NEVER end, even without error, so report that as an
                    // error. It can fail if the index DB goes down in some way.
                    // Restart it always.
                    if finished.end == TIP_POINT {
                        error!(chain=%cfg.chain, report=%finished, 
                            "The TIP follower failed, restarting it.");

                        // Start the Live Chain sync task again from where it left off.
                        sync_tasks.push(sync_subchain(finished.retry()));
                    } else if let Some(result) = finished.result.as_ref() {
                        match result {
                            Ok(()) => {
                                info!(chain=%cfg.chain, report=%finished,
                                    "The Immutable follower completed successfully.");
                            },
                            Err(error) => {
                                // let report = &finished.to_string();
                                error!(chain=%cfg.chain, report=%finished,
                                    "An Immutable follower failed, restarting it.");
                                // Start the Live Chain sync task again from where it left off.
                                sync_tasks.push(sync_subchain(finished.retry()));
                            },
                        }
                    } else {
                        error!(chain=%cfg.chain, report=%finished,
                                 "The Immutable follower completed, but without a proper result.");
                    }
                },
                Err(error) => {
                    error!(error=%error, "Sync task failed. Can not restart it, not enough information.  Sync is probably failed at this point.");
                },
            }
        }

        error!("Sync tasks have all stopped.  This is an unexpected error!");
    });

    Ok(())
}

const _UNUSED_CODE: &str = r#"

/// Spawn follower threads and return associated handlers
async fn spawn_followers(
    configs: Vec<FollowerConfig>, _data_refresh_tick: u64, machine_id: String,
) -> anyhow::Result<Vec<ManageTasks>> {
    let mut follower_tasks = Vec::new();

    for config in &configs {
        let follower_handler = spawn_follower(
            config.network,
            &config.relay,
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
    network: Network, relay: &str, machine_id: MachineId, snapshot: &str,
) -> anyhow::Result<ManageTasks> {
    // Establish point at which the last follower stopped updating in order to pick up
    // where it left off. If there was no previous follower, start indexing from
    // genesis point.
    let start_from = match EventDB::last_updated_state(network).await {
        Ok((slot_no, block_hash, _)) => Point::new(slot_no.try_into()?, block_hash),
        Err(err) if err.is::<NotFoundError>() => Point::Origin,
        Err(err) => return Err(err),
    };

    info!("Starting {network:?} follower from {start_from:?}",);

    let mut follower = instantiate_follower(start_from, snapshot, network, relay).await?;

    let genesis_values = network_genesis_values(&network)
        .ok_or(anyhow::anyhow!("Obtaining genesis values failed"))?;

    let task = tokio::spawn(async move {
        process_blocks(&mut follower, network, machine_id, &genesis_values).await;
    });

    Ok(task)
}

/// Process next block from the follower
async fn process_blocks(
    follower: &mut Follower, network: Network, machine_id: MachineId,
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
                                    index_block_buffer(&genesis_values, network, &machine_id, std::mem::take(&mut blocks_buffer)).await;

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
                        index_block_buffer(&genesis_values, network, &machine_id, current_buffer).await;

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
            Ok(chain_update) => {
                match chain_update {
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
                }
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
    genesis_values: &GenesisValues, network: Network, machine_id: &MachineId,
    buffer: Vec<cardano_chain_follower::MultiEraBlockData>,
) {
    info!("Starting data batch indexing");

    let mut blocks = Vec::new();

    for block_data in &buffer {
        match block_data.decode() {
            Ok(block) => blocks.push(block),
            Err(e) => {
                error!(error = ?e, "Failed to decode block");
            },
        }
    }

    match index_many_blocks(genesis_values, network, machine_id, &blocks).await {
        Ok(()) => {
            info!("Finished indexing data batch");
        },
        Err(e) => {
            error!(error = ?e, "Failed indexing data batch");
        },
    }
}

/// Index a slice of blocks.
async fn index_many_blocks(
    genesis_values: &GenesisValues, network: Network, machine_id: &MachineId,
    blocks: &[MultiEraBlock<'_>],
) -> anyhow::Result<()> {
    let Some(last_block) = blocks.last() else {
        return Ok(());
    };

    let network_str = network.to_string();

    index_blocks(genesis_values, &network_str, blocks).await?;
    index_transactions(blocks, &network_str).await?;
    index_voter_registrations(blocks, network).await?;

    match EventDB::refresh_last_updated(
        chrono::offset::Utc::now(),
        last_block.slot().try_into()?,
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

    Ok(())
}

/// Index the data from the given blocks.
async fn index_blocks(
    genesis_values: &GenesisValues, network_str: &str, blocks: &[MultiEraBlock<'_>],
) -> anyhow::Result<usize> {
    let values: Vec<_> = blocks
        .iter()
        .filter_map(|block| {
            IndexedFollowerDataParams::from_block_data(genesis_values, network_str, block)
        })
        .collect();

    EventDB::index_many_follower_data(&values)
        .await
        .context("Indexing block data")?;

    Ok(values.len())
}

/// Index transactions (and its inputs and outputs) from a slice of blocks.
async fn index_transactions(blocks: &[MultiEraBlock<'_>], network_str: &str) -> anyhow::Result<()> {
    let blocks_txs: Vec<_> = blocks
        .iter()
        .flat_map(|b| b.txs().into_iter().map(|tx| (b.slot(), tx)))
        .collect();

    index_transactions_data(network_str, &blocks_txs).await?;
    index_transaction_outputs_data(&blocks_txs).await?;
    index_transaction_inputs_data(&blocks_txs).await?;

    Ok(())
}

/// Index transactions data.
async fn index_transactions_data(
    network_str: &str, blocks_txs: &[(u64, MultiEraTx<'_>)],
) -> anyhow::Result<usize> {
    let values: Vec<_> = blocks_txs
        .iter()
        .map(|(slot, tx)| {
            Ok(IndexedTxnParams {
                id: tx.hash().to_vec(),
                slot_no: (*slot).try_into()?,
                network: network_str,
            })
        })
        .collect::<anyhow::Result<Vec<_>>>()?;

    EventDB::index_many_txn_data(&values)
        .await
        .context("Indexing transaction data")?;

    Ok(values.len())
}

/// Index transaction outputs data.
async fn index_transaction_outputs_data(
    blocks_txs: &[(u64, MultiEraTx<'_>)],
) -> anyhow::Result<usize> {
    let values: Vec<_> = blocks_txs
        .iter()
        .flat_map(|(_, tx)| IndexedTxnOutputParams::from_txn_data(tx))
        .collect();

    EventDB::index_many_txn_output_data(&values)
        .await
        .context("Indexing transaction outputs")?;

    Ok(values.len())
}

/// Index transaction inputs data.
async fn index_transaction_inputs_data(
    blocks_txs: &[(u64, MultiEraTx<'_>)],
) -> anyhow::Result<usize> {
    let values: Vec<_> = blocks_txs
        .iter()
        .flat_map(|(_, tx)| IndexedTxnInputParams::from_txn_data(tx))
        .collect();

    EventDB::index_many_txn_input_data(&values)
        .await
        .context("Indexing transaction inputs")?;

    Ok(values.len())
}

/// Index voter registrations from a slice of blocks.
async fn index_voter_registrations(
    blocks: &[MultiEraBlock<'_>], network: Network,
) -> anyhow::Result<usize> {
    let values: Vec<_> = blocks
        .iter()
        .filter_map(|block| IndexedVoterRegistrationParams::from_block_data(block, network))
        .flatten()
        .collect();

    EventDB::index_many_voter_registration_data(&values)
        .await
        .context("Indexing voter registration")?;

    Ok(values.len())
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

"#;
