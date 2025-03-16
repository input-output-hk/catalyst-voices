//! Logic for orchestrating followers

use std::time::Duration;

use cardano_blockchain_types::{Point, Slot};
use cardano_chain_follower::{ChainFollower, ChainSyncConfig};
use event::EventTarget;
use futures::{stream::FuturesUnordered, StreamExt};
use sync_params::SyncParams;
use tokio::sync::broadcast;
use tracing::{debug, error, info, warn};

use crate::{
    db::index::{
        block::{index_block, roll_forward},
        queries::sync_status::get::{get_sync_status, SyncStatus},
        session::CassandraSession,
    },
    settings::{chain_follower, Settings},
};

pub(crate) mod event;
mod sync_params;
pub(crate) mod util;

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

/// Sync a portion of the blockchain.
/// Set end to `Point::TIP` to sync the tip continuously.
fn sync_subchain(
    params: SyncParams, event_sender: broadcast::Sender<event::ChainIndexerEvent>,
) -> tokio::task::JoinHandle<SyncParams> {
    tokio::spawn(async move {
        info!(chain = %params.chain(), params=%params, "Indexing Blockchain");

        // Backoff hitting the database if we need to.
        params.backoff().await;

        // Wait for indexing DB to be ready before continuing.
        drop(CassandraSession::wait_until_ready(INDEXING_DB_READY_WAIT_INTERVAL, true).await);
        info!(chain=%params.chain(), params=%params,"Indexing DB is ready");

        let mut first_indexed_block = params.first_indexed_block().cloned();
        let mut first_immutable = params.first_is_immutable();
        let mut last_indexed_block = params.last_indexed_block().cloned();
        let mut last_immutable = params.last_is_immutable();
        let mut blocks_synced = 0u64;

        let mut follower =
            ChainFollower::new(*params.chain(), params.actual_start(), params.end().clone()).await;
        while let Some(chain_update) = follower.next().await {
            match chain_update.kind {
                cardano_chain_follower::Kind::ImmutableBlockRollForward => {
                    // We only process these on the follower tracking the TIP.
                    if params.end() == &Point::TIP {
                        // What we need to do here is tell the primary follower to start a new sync
                        // for the new immutable data, and then purge the volatile database of the
                        // old data (after the immutable data has synced).
                        info!(chain=%params.chain(), "Immutable chain rolled forward.");
                        let mut result = params.done(
                            first_indexed_block,
                            first_immutable,
                            last_indexed_block,
                            last_immutable,
                            blocks_synced,
                            Ok(()),
                        );
                        // Signal the point the immutable chain rolled forward to.
                        result.set_follower_roll_forward(chain_update.block_data().point());
                        return result;
                    };
                },
                cardano_chain_follower::Kind::Block => {
                    let block = chain_update.block_data();

                    if let Err(error) = index_block(block).await {
                        let error_msg = format!("Failed to index block {}", block.point());
                        error!(chain=%params.chain(), error=%error, params=%params, error_msg);
                        return params.done(
                            first_indexed_block,
                            first_immutable,
                            last_indexed_block,
                            last_immutable,
                            blocks_synced,
                            Err(error.context(error_msg)),
                        );
                    }

                    last_immutable = block.is_immutable();
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

                    let _ = event_sender.send(event::ChainIndexerEvent::ForwardDataPurged);
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

        info!(chain = %params.chain(), result=%result, "Indexing Blockchain Completed: OK");

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
        }
    }

    /// Primary Chain Follower task.
    ///
    /// This continuously runs in the background, and never terminates.
    async fn run(&mut self) {
        // We can't sync until the local chain data is synced.
        // This call will wait until we sync.
        let tips = ChainFollower::get_tips(self.cfg.chain).await;
        self.immutable_tip_slot = tips.0.slot_or_default();
        self.live_tip_slot = tips.1.slot_or_default();
        info!(chain=%self.cfg.chain, immutable_tip=?self.immutable_tip_slot, live_tip=?self.live_tip_slot, "Blockchain ready to sync from.");

        self.dispatch_event(event::ChainIndexerEvent::ImmutableTipSlotChanged {
            slot: self.immutable_tip_slot,
        });
        self.dispatch_event(event::ChainIndexerEvent::LiveTipSlotChanged {
            slot: self.live_tip_slot,
        });

        // Wait for indexing DB to be ready before continuing.
        // We do this after the above, because other nodes may have finished already, and we don't
        // want to wait do any work they already completed while we were fetching the blockchain.
        drop(CassandraSession::wait_until_ready(INDEXING_DB_READY_WAIT_INTERVAL, true).await);
        info!(chain=%self.cfg.chain, "Indexing DB is ready - Getting recovery state");
        self.sync_status = get_sync_status().await;
        debug!(chain=%self.cfg.chain, "Sync Status: {:?}", self.sync_status);

        // Start the Live Chain sync task - This can never end because it is syncing to TIP.
        // So, if it fails, it will automatically be restarted.
        self.sync_tasks.push(sync_subchain(
            SyncParams::new(
                self.cfg.chain,
                Point::fuzzy(self.immutable_tip_slot),
                Point::TIP,
            ),
            self.event_channel.0.clone(),
        ));

        self.start_immutable_followers();

        self.dispatch_event(event::ChainIndexerEvent::SyncStarted);

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
                    if finished.end() == &Point::TIP {
                        if let Some(roll_forward_point) = finished.follower_roll_forward() {
                            // Advance the known immutable tip, and try and start followers to reach
                            // it.
                            self.immutable_tip_slot = roll_forward_point.slot_or_default();

                            self.dispatch_event(
                                event::ChainIndexerEvent::ImmutableTipSlotChanged {
                                    slot: self.immutable_tip_slot,
                                },
                            );

                            self.start_immutable_followers();
                        } else {
                            error!(chain=%self.cfg.chain, report=%finished,
                            "The TIP follower failed, restarting it.");
                        }

                        // Start the Live Chain sync task again from where it left off.
                        self.sync_tasks.push(sync_subchain(
                            finished.retry(),
                            self.event_channel.0.clone(),
                        ));
                    } else if let Some(result) = finished.result() {
                        match result {
                            Ok(()) => {
                                self.current_sync_tasks =
                                    self.current_sync_tasks.checked_sub(1).unwrap_or_else(|| {
                                        error!("current_sync_tasks -= 1 overflow");
                                        0
                                    });
                                info!(chain=%self.cfg.chain, report=%finished,
                                    "The Immutable follower completed successfully.");

                                finished.last_indexed_block().inspect(|block| {
                                    self.dispatch_event(
                                        event::ChainIndexerEvent::IndexedSlotProgressed {
                                            slot: block.slot_or_default(),
                                        },
                                    );
                                });
                                self.dispatch_event(event::ChainIndexerEvent::SyncTasksChanged {
                                    current_sync_tasks: self.current_sync_tasks,
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
                                self.sync_tasks.push(sync_subchain(
                                    finished.retry(),
                                    self.event_channel.0.clone(),
                                ));
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
            // a parameter.sss
            if self.sync_tasks.len() == 1 {
                info!(chain=%self.cfg.chain, immutable_tip=u64::from(self.immutable_tip_slot), "Immutable State Indexing Finished");
                self.dispatch_event(event::ChainIndexerEvent::SyncCompleted);

                if let Err(error) = roll_forward::purge_live_index(self.immutable_tip_slot).await {
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
                    self.sync_tasks.push(sync_subchain(
                        SyncParams::new(self.cfg.chain, first_point, last_point.clone()),
                        self.event_channel.0.clone(),
                    ));
                    self.current_sync_tasks = self.current_sync_tasks.saturating_add(1);

                    self.dispatch_event(event::ChainIndexerEvent::SyncTasksChanged {
                        current_sync_tasks: self.current_sync_tasks,
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
            info!(chain=%self.cfg.chain, tasks=self.current_sync_tasks, until=?self.start_slot, "Persistent Indexing DB tasks started");
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
            while let Ok(event) = rx.recv().await {
                (listener)(&event);
            }
        });
    }

    fn dispatch_event(&self, message: event::ChainIndexerEvent) {
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
    info!(chain=%cfg.chain,"Chain Sync is started.");

    tokio::spawn(async move {
        use self::event::ChainIndexerEvent as Event;
        use crate::metrics::chain_indexer::reporter;

        let api_host_names = Settings::api_host_names().join(",");
        let service_id = Settings::service_id();
        let network = cfg.chain.to_string();

        let mut sync_task = SyncTask::new(cfg);

        // add an event listener to watch for certain events to report as metrics
        sync_task.add_event_listener(Box::new(move |event: &Event| {
            if let Event::SyncStarted = event {
                reporter::REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(0);
            }
            if let Event::SyncCompleted = event {
                reporter::REACHED_TIP
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(1);
            }
            if let Event::SyncTasksChanged { current_sync_tasks } = event {
                reporter::RUNNING_INDEXER_TASKS_COUNT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(From::from(*current_sync_tasks));
            }
            if let Event::LiveTipSlotChanged { slot } = event {
                reporter::CURRENT_LIVE_TIP_SLOT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(u64::from(*slot)).unwrap_or(-1));
            }
            if let Event::ImmutableTipSlotChanged { slot } = event {
                reporter::CURRENT_IMMUTABLE_TIP_SLOT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .set(i64::try_from(u64::from(*slot)).unwrap_or(-1));
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
            if let Event::ForwardDataPurged = event {
                reporter::TRIGGERED_FORWARD_PURGES_COUNT
                    .with_label_values(&[&api_host_names, service_id, &network])
                    .inc();
            }
        }));

        sync_task.run().await;
    });

    Ok(())
}
