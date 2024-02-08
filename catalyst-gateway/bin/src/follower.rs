use std::{error::Error, str::FromStr, sync::Arc};

use async_recursion::async_recursion;
use cardano_chain_follower::{
    network_genesis_values, ChainUpdate, Follower, FollowerConfigBuilder, Network, Point,
};

use tokio::time;
use tracing::{error, info};

use crate::{
    cli::CHECK_CONFIG_TICK,
    event_db::queries::{
        event::config::{FollowerMeta, NetworkMeta},
        EventDbQueries,
    },
};

#[async_recursion]
/// Start followers as per defined in the config
pub(crate) async fn start_followers(
    configs: (Vec<NetworkMeta>, FollowerMeta), db: Arc<dyn EventDbQueries>,
) -> Result<(), Box<dyn Error>> {
    let mut follower_tasks = Vec::new();

    for config in &configs.0 {
        info!("starting follower for {:?}", config.network);

        let (slot_no, block_hash, last_updated) =
            db.bootstrap_follower_from(config.network.clone()).await?;

        // threshold which defines if data is stale and ready to update or not
        if chrono::offset::Utc::now().timestamp() - last_updated.timestamp()
            > configs.1.timing_pattern.into()
        {
            info!(
                "Last update is stale for network {} - ready to update, starting follower now.",
                config.network
            );
            let task_handler = init_follower(
                config.network.clone(),
                config.relay.clone(),
                slot_no,
                block_hash,
                db.clone(),
            )
            .await?;
            follower_tasks.push(task_handler);
        } else {
            info!("data is fresh - do not start follower");
            // wait until threshold is met?
        }
    }

    let mut interval = time::interval(time::Duration::from_secs(CHECK_CONFIG_TICK));
    let config = loop {
        interval.tick().await;
        match db.get_config().await.map(|config| config) {
            Ok(config) => {
                if configs != config {
                    info!("config has changed! restarting");
                    break config;
                }
            },
            Err(err) => error!("no config {:?}", err),
        }
    };

    // stopping followers
    for task in follower_tasks {
        task.abort()
    }

    db.last_updated(chrono::offset::Utc::now()).await?;

    start_followers(config, db).await?;

    Ok(())
}

/// Initiate single follower
async fn init_follower(
    network: String, relay: String, slot_no: i64, block_hash: String, db: Arc<dyn EventDbQueries>,
) -> Result<tokio::task::JoinHandle<()>, Box<dyn Error>> {
    // Defaults to start following from the tip.
    let follower_cfg = FollowerConfigBuilder::default()
        .follow_from(Point::new(slot_no.try_into()?, hex::decode(block_hash)?))
        .build();

    let mut follower =
        Follower::connect(&relay, Network::from_str(&network)?, follower_cfg).await?;

    let genesis_values = network_genesis_values(&Network::from_str(&network)?)
        .expect("obtaining genesis values from follower crate is infallible");

    let task = tokio::spawn(async move {
        loop {
            let chain_update = follower.next().await.expect("infallible");

            match chain_update {
                ChainUpdate::Block(data) => {
                    let block = data.decode().expect("infallible");

                    match db
                        .updates_from_follower(
                            block.slot().try_into().expect("infallible"),
                            network.clone(),
                            block
                                .epoch(&genesis_values)
                                .0
                                .try_into()
                                .expect("infallible"),
                            block
                                .wallclock(&genesis_values)
                                .try_into()
                                .expect("infallible"),
                            hex::encode(block.hash()),
                        )
                        .await
                    {
                        Ok(_) => (),
                        Err(err) => {
                            error!("unable to index follower data {:?}", err);
                        },
                    }
                    // index the following

                    // utxo stuff

                    // registration stuff

                    // rewards stuff
                },
                ChainUpdate::Rollback(data) => {
                    let block = data.decode().expect("infallible");

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
