//! Logic for orchestrating followers

use cardano_chain_follower::{ChainFollower, ChainSyncConfig, Network, ORIGIN_POINT, TIP_POINT};
use tracing::{error, info, warn};

use crate::{db::index::block::index_block, settings::Settings};

pub(crate) mod cip36_registration;
pub(crate) mod util;

/// Blocks batch length that will trigger the blocks buffer to be written to the database.
#[allow(dead_code)]
const MAX_BLOCKS_BATCH_LEN: usize = 1024;

/// Start syncing a particular network
async fn start_sync_for(chain: Network) -> anyhow::Result<()> {
    let cfg = ChainSyncConfig::default_for(chain);
    info!(chain = cfg.chain.to_string(), "Starting Sync");

    if let Err(error) = cfg.run().await {
        error!(chain=%chain, error=%error, "Failed to start chain sync task");
        Err(error)?;
    }

    Ok(())
}

/// Start followers as per defined in the config
#[allow(unused)]
pub(crate) async fn start_followers() -> anyhow::Result<()> {
    let cfg = Settings::follower_cfg();

    cfg.log();

    start_sync_for(cfg.chain).await?;

    tokio::spawn(async move {
        // We can't sync until the local chain data is synced.
        // This call will wait until we sync.

        // Initially simple pure follower.
        // TODO, break the initial sync follower into multiple followers syncing the chain
        // to the index DB in parallel.
        info!(chain = %cfg.chain, "Following");
        let mut follower = ChainFollower::new(cfg.chain, ORIGIN_POINT, TIP_POINT).await;

        let mut blocks: u64 = 0;
        let mut hit_tip: bool = false;

        while let Some(chain_update) = follower.next().await {
            match chain_update.kind {
                cardano_chain_follower::Kind::ImmutableBlockRollForward => {
                    warn!("TODO: Immutable Chain roll forward");
                },
                cardano_chain_follower::Kind::Block => {
                    let block = chain_update.block_data();
                    if blocks == 0 {
                        info!("Indexing first block.");
                    }
                    blocks += 1;

                    if chain_update.tip && !hit_tip {
                        hit_tip = true;
                        info!("Hit tip after {blocks} blocks.");
                    }

                    if let Err(error) = index_block(block).await {
                        error!(chain=%cfg.chain, error=%error, "Failed to index block");
                        return;
                    }
                },
                cardano_chain_follower::Kind::Rollback => {
                    warn!("TODO: Live Chain rollback");
                },
            }
        }
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
