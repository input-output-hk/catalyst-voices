//! Config Queries
use std::str::FromStr;

use cardano_chain_follower::Network;
use serde::{Deserialize, Serialize};

use crate::event_db::{Error, EventDB};

#[derive(Debug, PartialEq, Clone)]
/// Network config metadata
pub(crate) struct FollowerConfig {
    /// Mainnet, preview, preprod
    pub(crate) network: Network,
    /// Cardano relay address
    pub(crate) relay: String,
    /// Mithril snapshot info
    pub(crate) mithril_snapshot: MithrilSnapshotConfig,
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Clone)]
/// Follower metadata
pub(crate) struct MithrilSnapshotConfig {
    /// Path to snapshot file for bootstrap
    pub(crate) path: String,
    /// Defines when data is stale or not
    pub(crate) timing_pattern: u8,
}

impl EventDB {
    /// Config query
    pub(crate) async fn get_follower_config(&self) -> Result<Vec<FollowerConfig>, Error> {
        let conn = self.pool.get().await?;

        let id = "cardano";
        let id2 = "follower";

        let rows = conn
            .query(
                include_str!("../../../event-db/queries/config/select_config.sql"),
                &[&id, &id2],
            )
            .await?;

        let mut follower_configs = Vec::new();
        for row in rows {
            let network = Network::from_str(row.try_get::<_, &str>("id3")?)
                .map_err(|e| Error::Unknown(e.to_string()))?;
            let config: serde_json::Value = row.try_get("value")?;

            let relay = config
                .get("relay")
                .ok_or(Error::JsonParseIssue(
                    "Cardano follower config does not have `relay` property".to_string(),
                ))?
                .as_str()
                .ok_or(Error::JsonParseIssue(
                    "Cardano follower config `relay` not a string type".to_string(),
                ))?
                .to_string();

            let mithril_snapshot = serde_json::from_value(
                config
                    .get("mithril_snapshot")
                    .ok_or(Error::JsonParseIssue(
                        "Cardano follower config does not have `mithril_snapshot` property"
                            .to_string(),
                    ))?
                    .clone(),
            )
            .map_err(|e| Error::JsonParseIssue(e.to_string()))?;

            follower_configs.push(FollowerConfig {
                network,
                relay,
                mithril_snapshot,
            });
        }

        if follower_configs.is_empty() {
            Err(Error::NoConfig)
        } else {
            Ok(follower_configs)
        }
    }
}
