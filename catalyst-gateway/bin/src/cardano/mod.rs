//! Logic for orchestrating followers

use std::{collections::BTreeSet, fmt::Display, ops::Sub, sync::Arc, time::Duration};

use cardano_blockchain_types::{MultiEraBlock, Network, Point, Slot};
use cardano_chain_follower::{ChainFollower, ChainSyncConfig};
use duration_string::DurationString;
use event::EventTarget;
use futures::{stream::FuturesUnordered, StreamExt};
use rand::{Rng, SeedableRng};
use tokio::sync::{broadcast, watch};
use tracing::{debug, error, info};

use crate::{
    db::index::{
        block::{
            index_block,
            roll_forward::{self, PurgeCondition},
        },
        queries::{
            caches,
            sync_status::{
                get::{get_sync_status, SyncStatus},
                update::update_sync_status,
            },
        },
        session::CassandraSession,
    },
    service::utilities::health::{
        set_follower_immutable_first_reached_tip, set_follower_live_first_reached_tip,
    },
    settings::{chain_follower, Settings},
};

pub(crate) mod event;

/// How long we wait between checks for connection to the indexing DB to be ready.
pub(crate) const INDEXING_DB_READY_WAIT_INTERVAL: Duration = Duration::from_secs(1);

/// Start syncing a particular network
async fn start_sync_for(cfg: &chain_follower::EnvVars) -> anyhow::Result<()> {
    let chain = cfg.chain;
    let dl_config = cfg.dl_config.clone();

    let mut cfg = ChainSyncConfig::default_for(chain);
    cfg.mithril_cfg = cfg.mithril_cfg.with_dl_config(dl_config);
    info!(chain = %chain, "Starting Chain Sync Task");

    if let Err(error) = cfg.run().await {
        error!(chain=%chain, error=%error, "Failed to start Chain Sync Task");
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
    /// Chain follower roll forward.
    follower_roll_forward: Option<Point>,
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
            follower_roll_forward: None,
        }
    }

    /// Convert a result back into parameters for a retry.
    fn retry(&self) -> Self {
        let retry_count = self.retries.saturating_add(1);

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
        retry.follower_roll_forward = None;

        retry
    }

    /// Convert Params into the result of the sync.
    pub(crate) fn done(
        &self, first: Option<Point>, first_immutable: bool, last: Option<Point>,
        last_immutable: bool, synced: u64, result: anyhow::Result<()>,
    ) -> Self {
        if result.is_ok() && self.end != Point::TIP {
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
        done.total_blocks_synced = done.total_blocks_synced.saturating_add(synced);
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
/// Set end to `Point::TIP` to sync the tip continuously.
#[allow(clippy::too_many_lines)]
fn sync_subchain(
    params: SyncParams, event_sender: broadcast::Sender<event::ChainIndexerEvent>,
    mut pending_blocks: watch::Receiver<BTreeSet<Slot>>,
) -> tokio::task::JoinHandle<SyncParams> {
    tokio::spawn(async move {
        // Backoff hitting the database if we need to.
        params.backoff().await;

        // Wait for indexing DB to be ready before continuing.
        drop(CassandraSession::wait_until_ready(INDEXING_DB_READY_WAIT_INTERVAL, true).await);
        info!(chain=%params.chain, params=%params,"Starting Chain Indexing Task");

        let mut first_indexed_block = params.first_indexed_block.clone();
        let mut first_immutable = params.first_is_immutable;
        let mut last_indexed_block = params.last_indexed_block.clone();
        let mut last_immutable = params.last_is_immutable;
        let mut blocks_synced = 0u64;

        let mut follower =
            ChainFollower::new(params.chain, params.actual_start(), params.end.clone()).await;
        while let Some(chain_update) = follower.next().await {
            let tips = ChainFollower::get_tips(params.chain).await;
            let immutable_slot = tips.0.slot_or_default();
            let live_slot = tips.1.slot_or_default();
            let event = event::ChainIndexerEvent::LiveTipSlotChanged {
                immutable_slot,
                live_slot,
            };
            if let Err(err) = event_sender.send(event) {
                error!(error=%err, "Unable to send event.");
            } else {
                debug!(live_tip_slot=?live_slot, "Chain Indexer update");
            }
            match chain_update.kind {
                cardano_chain_follower::Kind::ImmutableBlockRollForward => {
                    // We only process these on the follower tracking the TIP.
                    if params.end == Point::TIP {
                        // What we need to do here is tell the primary follower to start a new sync
                        // for the new immutable data, and then purge the volatile database of the
                        // old data (after the immutable data has synced).
                        info!(chain=%params.chain, point=?chain_update.block_data().point(), "Immutable chain rolled forward.");
                        let mut result = params.done(
                            first_indexed_block,
                            first_immutable,
                            last_indexed_block,
                            last_immutable,
                            blocks_synced,
                            Ok(()),
                        );
                        // Signal the point the immutable chain rolled forward to.
                        // If this is live chain immediately stops to later run immutable sync tasks
                        result.follower_roll_forward = Some(chain_update.block_data().point());
                        return result;
                    }
                },
                cardano_chain_follower::Kind::Block => {
                    let block = chain_update.block_data();

                    if let Err(error) =
                        index_block(block, &mut pending_blocks, params.end.slot_or_default()).await
                    {
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

                    if chain_update.tip && !set_follower_live_first_reached_tip() {
                        let _ = event_sender.send(event::ChainIndexerEvent::SyncLiveChainCompleted);
                    }

                    update_block_state(
                        block,
                        &mut first_indexed_block,
                        &mut first_immutable,
                        &mut last_indexed_block,
                        &mut last_immutable,
                        &mut blocks_synced,
                    );
                },

                cardano_chain_follower::Kind::Rollback => {
                    // Rollback occurs, need to purge forward
                    let rollback_slot = chain_update.block_data().slot();

                    let purge_condition = PurgeCondition::PurgeForwards(rollback_slot);
                    if let Err(error) = roll_forward::purge_live_index(purge_condition).await {
                        error!(chain=%params.chain, error=%error,
                            "Chain follower rollback, purging volatile data task failed."
                        );
                    } else {
                        // How many slots are purged
                        #[allow(clippy::arithmetic_side_effects)]
                        let purge_slots = params
                            .last_indexed_block
                            .as_ref()
                            // Slots arithmetic has saturating semantic, so this is ok
                            .map_or(0.into(), |l| l.slot_or_default() - rollback_slot);

                        let _ = event_sender.send(event::ChainIndexerEvent::ForwardDataPurged {
                            purge_slots: purge_slots.into(),
                        });

                        // Purge success, now index the current block
                        let block = chain_update.block_data();
                        if let Err(error) =
                            index_block(block, &mut pending_blocks, params.end.slot_or_default())
                                .await
                        {
                            let error_msg =
                                format!("Failed to index block after rollback {}", block.point());
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

                        update_block_state(
                            block,
                            &mut first_indexed_block,
                            &mut first_immutable,
                            &mut last_indexed_block,
                            &mut last_immutable,
                            &mut blocks_synced,
                        );
                    }
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

        info!(chain = %result.chain, result=%result, "Indexing Blockchain Completed: OK");

        result
    })
}

/// Update block related state.
fn update_block_state(
    block: &MultiEraBlock, first_indexed_block: &mut Option<Point>, first_immutable: &mut bool,
    last_indexed_block: &mut Option<Point>, last_immutable: &mut bool, blocks_synced: &mut u64,
) {
    *last_immutable = block.is_immutable();
    *last_indexed_block = Some(block.point());

    if first_indexed_block.is_none() {
        *first_immutable = *last_immutable;
        *first_indexed_block = Some(block.point());
    }

    *blocks_synced = blocks_synced.saturating_add(1);
}

/// The synchronisation task, and its state.
/// There should ONLY ever be one of these at any time.
struct SyncTask {
    /// Chain follower configuration.
    cfg: chain_follower::EnvVars,

    /// The current running sync tasks.
    sync_tasks: FuturesUnordered<tokio::task::JoinHandle<SyncParams>>,

    /// How many immutable chain follower sync tasks we are running.
    current_sync_tasks: u16,

    /// Start for the next block we would sync.
    start_slot: Slot,

    /// The immutable tip slot.
    immutable_tip_slot: Slot,

    /// The live tip slot.
    live_tip_slot: Slot,

    /// Current Sync Status.
    sync_status: Vec<SyncStatus>,

    /// Event sender during the process of sync tasks.
    event_channel: (
        broadcast::Sender<event::ChainIndexerEvent>,
        broadcast::Receiver<event::ChainIndexerEvent>,
    ),

    /// A channel that contains an end slot number for every immutable sync task.
    ///
    /// For example, if there are 3 tasks with `0..100`, `100..200` and `200..300` block
    /// ranges (where the end bounds aren't inclusive), then the channel will contain the
    /// following list: `[99, 199, 299]`. A slot value is removed when that task is done,
    /// so when the second task is finished the list will be updated to `[99, 299]`.
    pending_blocks: watch::Sender<BTreeSet<Slot>>,
}

impl SyncTask {
    /// Create a new `SyncTask`.
    fn new(cfg: chain_follower::EnvVars) -> SyncTask {
        Self {
            cfg,
            sync_tasks: FuturesUnordered::new(),
            start_slot: 0.into(),
            current_sync_tasks: 0,
            immutable_tip_slot: 0.into(),
            live_tip_slot: 0.into(),
            sync_status: Vec::new(),
            event_channel: broadcast::channel(10),
            pending_blocks: watch::channel(BTreeSet::new()).0,
        }
    }

    /// Add a new `SyncTask` to the queue.
    fn add_sync_task(
        &mut self, params: SyncParams, event_sender: broadcast::Sender<event::ChainIndexerEvent>,
    ) {
        self.pending_blocks.send_modify(|blocks| {
            blocks.insert(params.end.slot_or_default());
        });
        self.sync_tasks.push(sync_subchain(
            params,
            event_sender,
            self.pending_blocks.subscribe(),
        ));
        self.current_sync_tasks = self.current_sync_tasks.saturating_add(1);
        debug!(current_sync_tasks=%self.current_sync_tasks, "Added new Sync Task");
        self.dispatch_event(event::ChainIndexerEvent::SyncTasksChanged {
            current_sync_tasks: self.current_sync_tasks,
        });
    }

    /// Update `SyncTask` count.
    fn sync_task_finished(&mut self) {
        self.current_sync_tasks = self.current_sync_tasks.checked_sub(1).unwrap_or_else(|| {
            error!("current_sync_tasks -= 1 overflow");
            0
        });
        debug!(current_sync_tasks=%self.current_sync_tasks, "Finished Sync Task");
        self.dispatch_event(event::ChainIndexerEvent::SyncTasksChanged {
            current_sync_tasks: self.current_sync_tasks,
        });
    }

    /// Primary Chain Follower task.
    ///
    /// This continuously runs in the background, and never terminates.
    ///
    /// Sets the Index DB liveness flag to true if it is not already set.
    ///
    /// Sets the Chain Follower Has First Reached Tip flag to true if it is not already
    /// set.
    #[allow(clippy::too_many_lines)]
    async fn run(&mut self) {
        // We can't sync until the local chain data is synced.
        // This call will wait until we sync.
        let tips = ChainFollower::get_tips(self.cfg.chain).await;
        self.immutable_tip_slot = tips.0.slot_or_default();
        self.live_tip_slot = tips.1.slot_or_default();
        info!(chain=%self.cfg.chain, immutable_tip=?self.immutable_tip_slot, live_tip=?self.live_tip_slot, "Running the primary blockchain follower task.");

        self.dispatch_event(event::ChainIndexerEvent::ImmutableTipSlotChanged {
            immutable_slot: self.immutable_tip_slot,
            live_slot: self.live_tip_slot,
        });
        self.dispatch_event(event::ChainIndexerEvent::LiveTipSlotChanged {
            immutable_slot: self.immutable_tip_slot,
            live_slot: self.live_tip_slot,
        });

        // Wait for indexing DB to be ready before continuing.
        // We do this after the above, because other nodes may have finished already, and we don't
        // want to wait do any work they already completed while we were fetching the blockchain.
        //
        // After waiting, we set the liveness flag to true if it is not already set.
        drop(CassandraSession::wait_until_ready(INDEXING_DB_READY_WAIT_INTERVAL, true).await);

        info!(chain=%self.cfg.chain, "Indexing DB is ready - Getting recovery state for indexing");
        self.sync_status = get_sync_status().await;
        debug!(chain=%self.cfg.chain, "Sync Status: {:?}", self.sync_status);

        // Start the Live Chain sync task - This can never end because it is syncing to TIP.
        // So, if it fails, it will automatically be restarted.
        self.add_sync_task(
            SyncParams::new(
                self.cfg.chain,
                Point::fuzzy(self.immutable_tip_slot),
                Point::TIP,
            ),
            self.event_channel.0.clone(),
        );
        self.dispatch_event(event::ChainIndexerEvent::SyncLiveChainStarted);

        self.start_immutable_followers();
        // IF there is only 1 chain follower spawn, then the immutable state already indexed and
        // filled in the db.
        if self.sync_tasks.len() == 1 {
            set_follower_immutable_first_reached_tip();
            self.dispatch_event(event::ChainIndexerEvent::SyncImmutableChainCompleted);
        } else {
            self.dispatch_event(event::ChainIndexerEvent::SyncImmutableChainStarted);
        }

        // Wait Sync tasks to complete.  If they fail and have not completed, reschedule them.
        // If an immutable sync task ends OK, and we still have immutable data to sync then
        // start a new task.
        // They will return from this iterator in the order they complete.
        // This iterator actually never ends, because the live sync task is always restarted.
        while let Some(completed) = self.sync_tasks.next().await {
            // update sync task count
            self.sync_task_finished();

            match completed {
                Ok(finished) => {
                    let tips = ChainFollower::get_tips(self.cfg.chain).await;
                    let immutable_tip_slot = tips.0.slot_or_default();
                    let live_tip_slot = tips.1.slot_or_default();
                    info!(immutable_tip_slot=?immutable_tip_slot, live_tip_slot=?live_tip_slot, "Chain Indexer task finished");
                    // Sync task finished.  Check if it completed OK or had an error.
                    // If it failed, we need to reschedule it.

                    // The TIP follower should NEVER end, unless there is an immutable roll forward,
                    // or there is an error.  If this is not a roll forward, log an error.
                    // It can fail if the index DB goes down in some way.
                    // Restart it always.
                    if finished.end == Point::TIP {
                        if let Some(ref roll_forward_point) = finished.follower_roll_forward {
                            // Advance the known immutable tip, and try and start followers to reach
                            // it.
                            self.immutable_tip_slot = roll_forward_point.slot_or_default();

                            self.dispatch_event(
                                event::ChainIndexerEvent::ImmutableTipSlotChanged {
                                    immutable_slot: self.immutable_tip_slot,
                                    live_slot: self.live_tip_slot,
                                },
                            );
                            info!(chain=%self.cfg.chain, report=%finished, "Chain Indexer finished reaching TIP.");

                            self.start_immutable_followers();
                            self.dispatch_event(
                                event::ChainIndexerEvent::SyncImmutableChainStarted,
                            );
                        } else {
                            error!(chain=%self.cfg.chain, report=%finished, "Chain Indexer finished without to reach TIP.");
                        }

                        // Start the Live Chain sync task again from where it left off.
                        self.add_sync_task(finished.retry(), self.event_channel.0.clone());
                    } else if let Some(result) = finished.result.as_ref() {
                        match result {
                            Ok(()) => {
                                info!(chain=%self.cfg.chain, report=%finished,
                                    "The Immutable follower completed successfully.");

                                finished.last_indexed_block.as_ref().inspect(|block| {
                                    self.dispatch_event(
                                        event::ChainIndexerEvent::IndexedSlotProgressed {
                                            slot: block.slot_or_default(),
                                        },
                                    );
                                });

                                self.pending_blocks.send_modify(|blocks| {
                                    if !blocks.remove(&finished.end.slot_or_default()) {
                                        error!(chain=%self.cfg.chain, end=?finished.end,
                                            "The immutable follower completed successfully, but its end point isn't present in index_sync_channel"
                                        );
                                    }
                                });

                                // If we need more immutable chain followers to sync the block
                                // chain, we can now start them.
                                self.start_immutable_followers();
                            },
                            Err(error) => {
                                error!(chain=%self.cfg.chain, report=%finished, error=%error,
                                        "An Immutable follower failed, restarting it.");
                                // Restart the Immutable Chain sync task again from where it left
                                // off.
                                self.add_sync_task(finished.retry(), self.event_channel.0.clone());
                            },
                        }
                    } else {
                        error!(chain=%self.cfg.chain, report=%finished,
                        "BUG: The Immutable follower completed, but without a proper result.");
                    }
                },
                Err(error) => {
                    error!(chain=%self.cfg.chain, error=%error, "BUG: Sync task failed. Can not restart it, not enough information.  Sync is probably failed at this point.");
                },
            }

            // IF there is only 1 chain follower left in sync_tasks, then all
            // immutable followers have finished.
            // When this happens we need to purge the live index of any records that exist
            // before the current immutable tip.
            // Note: to prevent a data race when multiple nodes are syncing, we probably
            // want to put a gap in this, so that there are X slots of overlap
            // between the live chain and immutable chain.  This gap should be
            // a parameter.
            if self.sync_tasks.len() == 1 {
                set_follower_immutable_first_reached_tip();
                self.dispatch_event(event::ChainIndexerEvent::SyncImmutableChainCompleted);
                caches::txo_assets_by_stake::drop();
                caches::txo_by_stake::drop();

                // Purge data up to this slot
                // Slots arithmetic has saturating semantic, so this is ok.
                #[allow(clippy::arithmetic_side_effects)]
                let purge_to_slot =
                    self.immutable_tip_slot - Settings::purge_backward_slot_buffer();
                let purge_condition = PurgeCondition::PurgeBackwards(purge_to_slot);
                info!(chain=%self.cfg.chain, purge_to_slot=?purge_to_slot, "Backwards purging volatile data.");
                if let Err(error) = roll_forward::purge_live_index(purge_condition).await {
                    error!(chain=%self.cfg.chain, error=%error, "BUG: Purging volatile data task failed.");
                } else {
                    self.dispatch_event(event::ChainIndexerEvent::BackwardDataPurged);
                }
            }
        }

        error!(chain=%self.cfg.chain,"BUG: Sync tasks have all stopped.  This is an unexpected error!");
    }

    /// Start immutable followers, if we can
    fn start_immutable_followers(&mut self) {
        // Start the Immutable Chain sync tasks, as required.
        // We will start at most the number of configured sync tasks.
        // The live chain sync task is not counted as a sync task for this config value.

        // Nothing to do if the start_slot is not less than the end of the immutable chain.
        if self.start_slot < self.immutable_tip_slot {
            // Will also break if there are no more slots left to sync.
            while self.current_sync_tasks < self.cfg.sync_tasks {
                let end_slot = self.immutable_tip_slot.min(
                    (u64::from(self.start_slot).saturating_add(self.cfg.sync_chunk_max_slots))
                        .into(),
                );

                if let Some((first_point, last_point)) =
                    self.get_syncable_range(self.start_slot, end_slot)
                {
                    self.add_sync_task(
                        SyncParams::new(self.cfg.chain, first_point, last_point.clone()),
                        self.event_channel.0.clone(),
                    );
                }

                // The one slot overlap is deliberate, it doesn't hurt anything and prevents all off
                // by one problems that may occur otherwise.
                self.start_slot = end_slot;

                if end_slot == self.immutable_tip_slot {
                    break;
                }
            }
        }
    }

    /// Check if the requested range has already been indexed.
    /// If it hasn't just return the slots as points.
    /// If it has, return a subset that hasn't been indexed if any, or None if its been
    /// completely indexed already.
    fn get_syncable_range(&self, start: Slot, end: Slot) -> Option<(Point, Point)> {
        for sync_block in &self.sync_status {
            // Check if we start within a previously synchronized block.
            if start >= sync_block.start_slot && start <= sync_block.end_slot {
                // Check if we are fully contained by the sync block, if so, nothing to sync.
                if end <= sync_block.end_slot {
                    return None;
                }

                // In theory, we could extend into another sync block, but because we could extend
                // into an unbounded number of sync blocks, we would need to bust
                // this range into an unbounded number of sub chunks.
                // It is not a problem to sync the same data mutiple times, so for simplicity we do
                // not account for this, if the requested range goes beyond the sync
                // block it starts within we assume that the rest is not synced.
                return Some((Point::fuzzy(sync_block.end_slot), Point::fuzzy(end)));
            }
        }

        let start_slot = if start == 0.into() {
            Point::ORIGIN
        } else {
            Point::fuzzy(start)
        };

        Some((start_slot, Point::fuzzy(end)))
    }
}

impl event::EventTarget<event::ChainIndexerEvent> for SyncTask {
    fn add_event_listener(&mut self, listener: event::EventListenerFn<event::ChainIndexerEvent>) {
        let mut rx = self.event_channel.0.subscribe();
        tokio::spawn(async move {
            loop {
                match rx.recv().await {
                    Ok(event) => (listener)(&event),
                    Err(broadcast::error::RecvError::Lagged(lag)) => {
                        debug!(lag = lag, "Sync tasks event listener lagged");
                    },
                    Err(broadcast::error::RecvError::Closed) => break,
                }
            }
        });
    }

    fn dispatch_event(&self, message: event::ChainIndexerEvent) {
        debug!(event = ?message, "Chain Indexer Event");
        let _ = self.event_channel.0.send(message);
    }
}

/// Start followers as per defined in the config
pub(crate) async fn start_followers() -> anyhow::Result<()> {
    let cfg = Settings::follower_cfg();

    // Log the chain follower configuration.
    cfg.log();

    // Start Syncing the blockchain, so we can consume its data as required.
    start_sync_for(&cfg).await?;

    tokio::spawn(async move {
        use self::event::ChainIndexerEvent as Event;
        use crate::metrics::chain_indexer::reporter;

        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = cfg.chain.to_string();

        let mut sync_task = SyncTask::new(cfg);

        // add an event listener to watch for certain events to report as metrics
        sync_task.add_event_listener(Box::new(move |event: &Event| {
            if let Event::SyncLiveChainStarted = event {
                reporter::LIVE_REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(0);
            }
            if let Event::SyncImmutableChainStarted = event {
                reporter::IMMUTABLE_REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(0);
            }
            if let Event::SyncLiveChainCompleted = event {
                reporter::LIVE_REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(1);
            }
            if let Event::SyncImmutableChainCompleted = event {
                reporter::IMMUTABLE_REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(1);
            }
            if let Event::SyncTasksChanged { current_sync_tasks } = event {
                reporter::RUNNING_INDEXER_TASKS_COUNT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(From::from(*current_sync_tasks));
            }
            if let Event::LiveTipSlotChanged {
                live_slot,
                immutable_slot,
            } = event
            {
                reporter::CURRENT_LIVE_TIP_SLOT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(u64::from(*live_slot)).unwrap_or(-1));
                reporter::SLOT_TIP_DIFF
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(
                        u64::from(live_slot.sub(*immutable_slot))
                            .try_into()
                            .unwrap_or(-1),
                    );
            }
            if let Event::ImmutableTipSlotChanged {
                live_slot,
                immutable_slot,
            } = event
            {
                reporter::CURRENT_IMMUTABLE_TIP_SLOT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(u64::from(*immutable_slot)).unwrap_or(-1));

                reporter::SLOT_TIP_DIFF
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(
                        u64::from(live_slot.sub(*immutable_slot))
                            .try_into()
                            .unwrap_or(-1),
                    );
            }
            if let Event::IndexedSlotProgressed { slot } = event {
                reporter::HIGHEST_COMPLETE_INDEXED_SLOT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(u64::from(*slot)).unwrap_or(-1));
            }
            if let Event::BackwardDataPurged = event {
                reporter::TRIGGERED_BACKWARD_PURGES_COUNT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();
            }
            if let Event::ForwardDataPurged { purge_slots } = event {
                reporter::TRIGGERED_FORWARD_PURGES_COUNT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();
                reporter::PURGED_SLOTS
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(*purge_slots).unwrap_or(-1));
            }
        }));

        sync_task.run().await;
    });

    Ok(())
}
