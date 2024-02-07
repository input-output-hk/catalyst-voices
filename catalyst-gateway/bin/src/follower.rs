use std::{error::Error, str::FromStr, sync::Arc};

use cardano_chain_follower::{
    network_genesis_values, ChainUpdate, Follower, FollowerConfigBuilder, Network, Point,
};
use tracing::{error, info};

use crate::event_db::queries::{
    event::config::{FollowerMeta, NetworkMeta},
    EventDbQueries,
};

/// Start followers as per defined in the config
pub(crate) async fn start_followers(
    configs: (Vec<NetworkMeta>, FollowerMeta), db: Arc<dyn EventDbQueries>,
) -> Result<(), Box<dyn Error>> {
    info!("{:?}", configs);

    for config in configs.0 {
        info!("starting follower for {:?}", config.network);
        init_follower(config, db.clone()).await?;
    }

    Ok(())
}

/// Initiate single follower
async fn init_follower(
    network: NetworkMeta, db: Arc<dyn EventDbQueries>,
) -> Result<(), Box<dyn Error>> {
    let (slot_no, block_hash) = db.bootstrap_follower_from(network.network.clone()).await?;

    // Defaults to start following from the tip.
    let follower_cfg = FollowerConfigBuilder::default()
        .follow_from(Point::new(slot_no.try_into()?, hex::decode(block_hash)?))
        .build();

    let mut follower = Follower::connect(
        &network.relay,
        Network::from_str(&network.network)?,
        follower_cfg,
    )
    .await?;

    let genesis_values = network_genesis_values(&Network::from_str(&network.network)?)
        .expect("obtaining genesis values from follower crate is infallible");

    // Check most recent update on cardano update table If it falls within the threshold boundary, node should update db with latest data

    // instead of loop, close follower when updates finished
    tokio::spawn(async move {
        loop {
            // wait for interupt

            let chain_update = follower.next().await.expect("infallible");

            match chain_update {
                ChainUpdate::Block(data) => {
                    let block = data.decode().expect("infallible");

                    match db
                        .updates_from_follower(
                            block.slot().try_into().expect("infallible"),
                            network.network.clone(),
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

    Ok(())
}
