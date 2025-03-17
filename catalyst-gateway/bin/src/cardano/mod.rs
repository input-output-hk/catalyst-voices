//! Chain follower syncing.

use cardano_chain_follower::ChainSyncConfig;
use event::EventTarget;
use sync_task::SyncTask;
use tracing::{error, info};

use crate::settings::{chain_follower, Settings};

pub(crate) mod event;
mod sync_params;
mod sync_task;
pub(crate) mod util;

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
