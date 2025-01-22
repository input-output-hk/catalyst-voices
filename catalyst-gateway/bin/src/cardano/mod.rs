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
        block::{index_block, roll_forward},
        queries::sync_status::{
            get::{get_sync_status, SyncStatus},
            update::update_sync_status,
        },
        session::CassandraSession,
    },
    settings::{chain_follower, Settings},
};

// pub(crate) mod cip36_registration_obsolete;
pub(crate) mod types;
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
                        // What we need to do here is tell the primary follower to start a new sync
                        // for the new immutable data, and then purge the volatile database of the
                        // old data (after the immutable data has synced).
                        info!(chain=%params.chain, "Immutable chain rolled forward.");
                        let mut result = params.done(
                            first_indexed_block,
                            first_immutable,
                            last_indexed_block,
                            last_immutable,
                            blocks_synced,
                            Ok(()),
                        );
                        // Signal the point the immutable chain rolled forward to.
                        result.follower_roll_forward = Some(chain_update.block_data().point());
                        return result;
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
                    blocks_synced = blocks_synced.saturating_add(1);
                },
                cardano_chain_follower::Kind::Rollback => {
                    warn!("TODO: Live Chain rollback");
                    // What we need to do here, is purge the live DB of records after the
                    // rollback point.  We need to complete this operation here
                    // before we keep syncing the live chain.
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

/// The synchronisation task, and its state.
/// There should ONLY ever be one of these at any time.
struct SyncTask {
    /// Chain follower configuration.
    cfg: chain_follower::EnvVars,

    /// The current running sync tasks.
    sync_tasks: FuturesUnordered<tokio::task::JoinHandle<SyncParams>>,

    /// // How many immutable chain follower sync tasks we are running.
    current_sync_tasks: u16,

    /// Start for the next block we would sync.
    start_slot: u64,

    /// The immutable tip slot.
    immutable_tip_slot: u64,

    /// The live tip slot.
    live_tip_slot: u64,

    /// Current Sync Status
    sync_status: Vec<SyncStatus>,
}

impl SyncTask {
    /// Create a new `SyncTask`.
    fn new(cfg: chain_follower::EnvVars) -> SyncTask {
        SyncTask {
            cfg,
            sync_tasks: FuturesUnordered::new(),
            start_slot: 0,
            current_sync_tasks: 0,
            immutable_tip_slot: 0,
            live_tip_slot: 0,
            sync_status: Vec::new(),
        }
    }

    /// Primary Chain Follower task.
    ///
    /// This continuously runs in the background, and never terminates.
    async fn run(&mut self) {
        // We can't sync until the local chain data is synced.
        // This call will wait until we sync.
        let tips = cardano_chain_follower::ChainFollower::get_tips(self.cfg.chain).await;
        self.immutable_tip_slot = tips.0.slot_or_default();
        self.live_tip_slot = tips.1.slot_or_default();
        info!(chain=%self.cfg.chain, immutable_tip=self.immutable_tip_slot, live_tip=self.live_tip_slot, "Blockchain ready to sync from.");

        // Wait for indexing DB to be ready before continuing.
        // We do this after the above, because other nodes may have finished already, and we don't
        // want to wait do any work they already completed while we were fetching the blockchain.
        CassandraSession::wait_is_ready(INDEXING_DB_READY_WAIT_INTERVAL).await;
        info!(chain=%self.cfg.chain, "Indexing DB is ready - Getting recovery state");
        self.sync_status = get_sync_status().await;
        debug!(chain=%self.cfg.chain, "Sync Status: {:?}", self.sync_status);

        // Start the Live Chain sync task - This can never end because it is syncing to TIP.
        // So, if it fails, it will automatically be restarted.
        self.sync_tasks.push(sync_subchain(SyncParams::new(
            self.cfg.chain,
            cardano_chain_follower::Point::fuzzy(self.immutable_tip_slot),
            TIP_POINT,
        )));

        self.start_immutable_followers();

        // Wait Sync tasks to complete.  If they fail and have not completed, reschedule them.
        // If an immutable sync task ends OK, and we still have immutable data to sync then
        // start a new task.
        // They will return from this iterator in the order they complete.
        // This iterator actually never ends, because the live sync task is always restarted.
        while let Some(completed) = self.sync_tasks.next().await {
            match completed {
                Ok(finished) => {
                    // Sync task finished.  Check if it completed OK or had an error.
                    // If it failed, we need to reschedule it.

                    // The TIP follower should NEVER end, unless there is an immutable roll forward,
                    // or there is an error.  If this is not a roll forward, log an error.
                    // It can fail if the index DB goes down in some way.
                    // Restart it always.
                    if finished.end == TIP_POINT {
                        if let Some(ref roll_forward_point) = finished.follower_roll_forward {
                            // Advance the known immutable tip, and try and start followers to reach
                            // it.
                            self.immutable_tip_slot = roll_forward_point.slot_or_default();
                            self.start_immutable_followers();
                        } else {
                            error!(chain=%self.cfg.chain, report=%finished,
                            "The TIP follower failed, restarting it.");
                        }

                        // Start the Live Chain sync task again from where it left off.
                        self.sync_tasks.push(sync_subchain(finished.retry()));
                    } else if let Some(result) = finished.result.as_ref() {
                        match result {
                            Ok(()) => {
                                self.current_sync_tasks =
                                    self.current_sync_tasks.checked_sub(1).unwrap_or_else(|| {
                                        error!("current_sync_tasks -= 1 overflow");
                                        0
                                    });
                                info!(chain=%self.cfg.chain, report=%finished,
                                    "The Immutable follower completed successfully.");

                                // If we need more immutable chain followers to sync the block
                                // chain, we can now start them.
                                self.start_immutable_followers();
                            },
                            Err(error) => {
                                error!(chain=%self.cfg.chain, report=%finished, error=%error,
                                    "An Immutable follower failed, restarting it.");
                                // Restart the Immutable Chain sync task again from where it left
                                // off.
                                self.sync_tasks.push(sync_subchain(finished.retry()));
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
                if let Err(error) = roll_forward::purge_live_index(self.immutable_tip_slot).await {
                    error!(chain=%self.cfg.chain, error=%error, "BUG: Purging volatile data task failed.");
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
                    self.start_slot
                        .saturating_add(self.cfg.sync_chunk_max_slots),
                );

                if let Some((first_point, last_point)) =
                    self.get_syncable_range(self.start_slot, end_slot)
                {
                    self.sync_tasks.push(sync_subchain(SyncParams::new(
                        self.cfg.chain,
                        first_point,
                        last_point.clone(),
                    )));
                    self.current_sync_tasks = self.current_sync_tasks.saturating_add(1);
                }

                // The one slot overlap is deliberate, it doesn't hurt anything and prevents all off
                // by one problems that may occur otherwise.
                self.start_slot = end_slot;

                if end_slot == self.immutable_tip_slot {
                    break;
                }
            }
            // `start_slot` is still used, because it is used to keep syncing chunks as required
            // while each immutable sync task finishes.
            info!(chain=%self.cfg.chain, tasks=self.current_sync_tasks, until=self.start_slot, "Persistent Indexing DB tasks started");
        }
    }

    /// Check if the requested range has already been indexed.
    /// If it hasn't just return the slots as points.
    /// If it has, return a subset that hasn't been indexed if any, or None if its been
    /// completely indexed already.
    fn get_syncable_range(&self, start: u64, end: u64) -> Option<(Point, Point)> {
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
                return Some((
                    cardano_chain_follower::Point::fuzzy(sync_block.end_slot),
                    cardano_chain_follower::Point::fuzzy(end),
                ));
            }
        }

        let start_slot = if start == 0 {
            ORIGIN_POINT
        } else {
            cardano_chain_follower::Point::fuzzy(start)
        };

        Some((start_slot, cardano_chain_follower::Point::fuzzy(end)))
    }
}

/// Start followers as per defined in the config
pub(crate) async fn start_followers() -> anyhow::Result<()> {
    let cfg = Settings::follower_cfg();

    // Log the chain follower configuration.
    cfg.log();

    // Start Syncing the blockchain, so we can consume its data as required.
    start_sync_for(&cfg).await?;
    info!(chain=%cfg.chain,"Chain Sync is started.");

    tokio::spawn(async move {
        let mut sync_task = SyncTask::new(cfg);
        sync_task.run().await;
    });

    Ok(())
}
