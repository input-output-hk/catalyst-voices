//! Chain follower syncing tasks orchestrating.

use std::time::Duration;

use cardano_blockchain_types::{Point, Slot};
use cardano_chain_follower::ChainFollower;
use futures::{stream::FuturesUnordered, StreamExt};
use tokio::sync::broadcast;
use tracing::{debug, error, info};

use super::{
    event::{ChainIndexerEvent, EventListenerFn, EventTarget},
    sync_params::SyncParams,
};
use crate::{
    db::index::{
        block::{
            index_block,
            roll_forward::{self, PurgeCondition},
        },
        queries::sync_status::get::{get_sync_status, SyncStatus},
        session::CassandraSession,
    },
    settings::{chain_follower, Settings},
};

/// How long we wait between checks for connection to the indexing DB to be ready.
const INDEXING_DB_READY_WAIT_INTERVAL: Duration = Duration::from_secs(1);

/// The synchronisation task, and its state.
/// There should ONLY ever be one of these at any time.
pub(crate) struct SyncTask {
    /// Chain follower configuration.
    cfg: chain_follower::EnvVars,

    /// The current running sync tasks.
    sync_tasks: FuturesUnordered<tokio::task::JoinHandle<SyncParams>>,

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
        broadcast::Sender<ChainIndexerEvent>,
        broadcast::Receiver<ChainIndexerEvent>,
    ),
}

impl SyncTask {
    /// Create a new `SyncTask`.
    pub(crate) fn new(cfg: chain_follower::EnvVars) -> SyncTask {
        Self {
            cfg,
            sync_tasks: FuturesUnordered::new(),
            start_slot: 0.into(),
            immutable_tip_slot: 0.into(),
            live_tip_slot: 0.into(),
            sync_status: Vec::new(),
            event_channel: broadcast::channel(10),
        }
    }

    /// Primary Chain Follower task.
    ///
    /// This continuously runs in the background, and never terminates.
    pub(crate) async fn run(&mut self) {
        // We can't sync until the local chain data is synced.
        // This call will wait until we sync.
        let tips = ChainFollower::get_tips(self.cfg.chain).await;
        self.immutable_tip_slot = tips.0.slot_or_default();
        self.live_tip_slot = tips.1.slot_or_default();
        info!(chain=%self.cfg.chain, immutable_tip=?self.immutable_tip_slot, live_tip=?self.live_tip_slot, "Blockchain ready to sync from.");

        self.dispatch_event(ChainIndexerEvent::ImmutableTipSlotChanged {
            slot: self.immutable_tip_slot,
        });
        self.dispatch_event(ChainIndexerEvent::LiveTipSlotChanged {
            slot: self.live_tip_slot,
        });

        // Wait for indexing DB to be ready before continuing.
        // We do this after the above, because other nodes may have finished already, and we don't
        // want to wait do any work they already completed while we were fetching the blockchain.
        drop(CassandraSession::wait_until_ready(INDEXING_DB_READY_WAIT_INTERVAL, true).await);
        info!(chain=%self.cfg.chain, "Indexing DB is ready - Getting recovery state");
        self.sync_status = get_sync_status().await;
        debug!(chain=%self.cfg.chain, "Sync Status: {:?}", self.sync_status);

        self.start_immutable_followers();

        self.dispatch_event(ChainIndexerEvent::SyncStarted);

        while let Some(completed) = self.sync_tasks.next().await {
            self.process_completed_task(completed.map_err(Into::into));

            // IF there is no chain followers left in sync_tasks, then all
            // immutable followers have finished.
            // When this happens we need to purge the live index of any records that exist
            // before the current immutable tip.
            // Note: to prevent a data race when multiple nodes are syncing, we probably
            // want to put a gap in this, so that there are X slots of overlap
            // between the live chain and immutable chain.  This gap should be
            // a parameter.
            if self.sync_tasks.is_empty() {
                info!(chain=%self.cfg.chain, immutable_tip=?self.immutable_tip_slot, "Immutable State Indexing Finished");
                self.dispatch_event(ChainIndexerEvent::SyncCompleted);

                // Purge data up to this slot
                // Slots arithmetic has saturating semantic, so this is ok.
                #[allow(clippy::arithmetic_side_effects)]
                let purge_to_slot =
                    self.immutable_tip_slot - Settings::purge_backward_slot_buffer();
                let purge_condition = PurgeCondition::PurgeBackwards(purge_to_slot);
                if let Err(error) = roll_forward::purge_live_index(purge_condition).await {
                    error!(chain=%self.cfg.chain, error=%error, "BUG: Purging volatile data task failed.");
                } else {
                    self.dispatch_event(ChainIndexerEvent::BackwardDataPurged);
                }

                self.start_live_chain_follower();
            }
        }

        error!(chain=%self.cfg.chain,"BUG: Sync tasks have all stopped.  This is an unexpected error!");
    }

    /// Start immutable followers
    fn start_immutable_followers(&mut self) {
        // Start the Immutable Chain sync tasks, as required.
        // We will start at most the number of configured sync tasks.
        // The live chain sync task is not counted as a sync task for this config value.

        // Nothing to do if the start_slot is not less than the end of the immutable chain.
        if self.start_slot < self.immutable_tip_slot {
            // Will also break if there are no more slots left to sync.
            while self.sync_tasks.len() < self.cfg.sync_tasks {
                let end_slot = self.immutable_tip_slot.min(
                    (u64::from(self.start_slot).saturating_add(self.cfg.sync_chunk_max_slots))
                        .into(),
                );

                if let Some((first_point, last_point)) =
                    self.get_syncable_range(self.start_slot, end_slot)
                {
                    self.sync_tasks.push(sync_subchain(
                        SyncParams::new_immutable(self.cfg.chain, first_point, last_point.clone()),
                        self.event_channel.0.clone(),
                    ));

                    self.dispatch_event(ChainIndexerEvent::SyncTasksChanged {
                        current_sync_tasks: self.sync_tasks.len(),
                    });
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
            info!(chain=%self.cfg.chain, tasks=self.sync_tasks.len(), until=?self.start_slot, "Immutable follower syncing tasks started.");
        }
    }

    /// Start only one live chain follower
    fn start_live_chain_follower(&mut self) {
        if self.sync_tasks.len() < self.cfg.sync_tasks {
            self.sync_tasks.push(sync_subchain(
                SyncParams::new_live(self.cfg.chain, Point::fuzzy(self.immutable_tip_slot)),
                self.event_channel.0.clone(),
            ));
        }
    }

    /// Process completed sync tasks
    /// If they fail and have not completed, reschedule them.
    // If an immutable sync task ends OK, and we still have immutable data to sync then
    // start a new task.
    // They will return from this iterator in the order they complete.
    // This iterator actually never ends, because the live sync task is always restarted.
    fn process_completed_task(&mut self, completed: anyhow::Result<SyncParams>) {
        let finished = match completed {
            Ok(finished) => finished,
            Err(error) => {
                error!(chain=%self.cfg.chain, error=%error,
                    "BUG: Sync task failed. Can not restart it, not enough information. Sync is probably failed at this point."
                );
                return;
            },
        };
        // If there is a roll forward we want to start indexing immutable followers to catch up
        // with the immutable state
        if let Some(roll_forward_point) = finished.follower_roll_forward() {
            // Advance the known immutable tip, and try and start followers to reach
            // it.
            self.immutable_tip_slot = roll_forward_point.slot_or_default();

            self.dispatch_event(ChainIndexerEvent::ImmutableTipSlotChanged {
                slot: self.immutable_tip_slot,
            });

            self.start_immutable_followers();
        }

        // Sync task finished.  Check if it completed OK or had an error.
        // If it failed, we need to reschedule it.
        if let Some(error) = finished.error() {
            error!(chain=%self.cfg.chain, report=%finished, error=%error,
                "An Follower sync task failed, restarting it."
            );
            // Restart the Follower Chain sync task again from where it left
            // off.
            self.sync_tasks.push(sync_subchain(
                finished.retry(),
                self.event_channel.0.clone(),
            ));
        } else {
            info!(chain=%self.cfg.chain, report=%finished,
                "The Follower sync task completed successfully."
            );

            finished.last_indexed_block().inspect(|block| {
                self.dispatch_event(ChainIndexerEvent::IndexedSlotProgressed {
                    slot: block.slot_or_default(),
                });
            });
            self.dispatch_event(ChainIndexerEvent::SyncTasksChanged {
                current_sync_tasks: self.sync_tasks.len(),
            });

            // If we need more immutable chain followers to sync the block
            // chain, we can now start them.
            self.start_immutable_followers();
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

impl EventTarget<ChainIndexerEvent> for SyncTask {
    fn add_event_listener(&mut self, listener: EventListenerFn<ChainIndexerEvent>) {
        let mut rx = self.event_channel.0.subscribe();
        tokio::spawn(async move {
            while let Ok(event) = rx.recv().await {
                (listener)(&event);
            }
        });
    }

    fn dispatch_event(&self, message: ChainIndexerEvent) {
        let _ = self.event_channel.0.send(message);
    }
}

/// Sync a portion of the blockchain.
/// Set end to `Point::TIP` to sync the tip continuously.
fn sync_subchain(
    mut params: SyncParams, event_sender: broadcast::Sender<ChainIndexerEvent>,
) -> tokio::task::JoinHandle<SyncParams> {
    tokio::spawn(async move {
        info!(chain = %params.chain(), params=%params, "Indexing Blockchain");

        // Backoff hitting the database if we need to.
        params.backoff().await;

        // Wait for indexing DB to be ready before continuing.
        drop(CassandraSession::wait_until_ready(INDEXING_DB_READY_WAIT_INTERVAL, true).await);
        info!(chain=%params.chain(), params=%params,"Indexing DB is ready");

        let mut follower =
            ChainFollower::new(*params.chain(), params.actual_start(), params.end().clone()).await;
        while let Some(chain_update) = follower.next().await {
            match chain_update.kind {
                cardano_chain_follower::Kind::ImmutableBlockRollForward => {
                    // What we need to do here is tell the primary follower to start a new sync
                    // for the new immutable data, and then purge the volatile database of the
                    // old data (after the immutable data has synced).
                    info!(chain=%params.chain(), "Immutable chain rolled forward.");
                    // Signal the point the immutable chain rolled forward to.
                    params.set_follower_roll_forward(chain_update.block_data().point());
                    // If this task is imm
                    if !params.is_immutable() {
                        return params.done(None);
                    }
                },
                cardano_chain_follower::Kind::Block => {
                    let block = chain_update.block_data();

                    if let Err(error) = index_block(block).await {
                        let error =
                            error.context(format!("Failed to index block {}", block.point()));
                        return params.done(Some(error));
                    }

                    params.update_block_state(block);
                },
                cardano_chain_follower::Kind::Rollback => {
                    // Rollback occurs, need to purge forward
                    let rollback_slot = chain_update.block_data().slot();

                    let purge_condition = PurgeCondition::PurgeForwards(rollback_slot);
                    if let Err(error) = roll_forward::purge_live_index(purge_condition).await {
                        error!(chain=%params.chain(), error=%error,
                            "Chain follower rollback, purging volatile data task failed."
                        );
                    } else {
                        // How many slots are purged
                        #[allow(clippy::arithmetic_side_effects)]
                        let purge_slots = params
                            .last_indexed_block()
                            // Slots arithmetic has saturating semantic, so this is ok
                            .map_or(0.into(), |l| l.slot_or_default() - rollback_slot);

                        let _ = event_sender.send(ChainIndexerEvent::ForwardDataPurged {
                            purge_slots: purge_slots.into(),
                        });

                        // Purge success, now index the current block
                        let block = chain_update.block_data();
                        if let Err(error) = index_block(block).await {
                            let error = error.context(format!(
                                "Failed to index block after rollback {}",
                                block.point()
                            ));
                            return params.done(Some(error));
                        }

                        params.update_block_state(block);
                    }
                },
            }
        }

        let result = params.done(None);
        info!(chain = %result.chain(), result=%result, "Indexing Blockchain Completed: OK");
        result
    })
}
