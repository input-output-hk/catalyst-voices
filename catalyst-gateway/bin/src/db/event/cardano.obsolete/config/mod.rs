//! Follower config queries
use std::str::FromStr;

use cardano_chain_follower::Network;
use serde::{Deserialize, Serialize};

use crate::db::event::{error::NotFoundError, EventDB};

/// Representation of the `config` table id fields `id`, `id2`, `id3`
enum ConfigId {
    /// `id` field
    Id,
    /// `id2` field
    Id2,
    /// `id3` field
    Id3,
}

impl ConfigId {
    /// Returns the id field as a string
    fn as_str(&self) -> &str {
        match self {
            ConfigId::Id => "id",
            ConfigId::Id2 => "id2",
            ConfigId::Id3 => "id3",
        }
    }
}

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

/// `select_config.sql`
const SELECT_CONFIG_SQL: &str = include_str!("select_config.sql");

impl EventDB {
    /// Config query
    pub(crate) async fn get_follower_config() -> anyhow::Result<Vec<FollowerConfig>> {
        let id = "cardano";
        let id2 = "follower";

        let rows = Self::query(SELECT_CONFIG_SQL, &[&id, &id2]).await?;

        let mut follower_configs = Vec::new();
        for row in rows {
            let network = Network::from_str(row.try_get::<_, &str>(ConfigId::Id3.as_str())?)?;
            let config: serde_json::Value = row.try_get("value")?;

            let relay = config
                .get("relay")
                .ok_or(anyhow::anyhow!(
                    "Cardano follower config does not have `relay` property".to_string(),
                ))?
                .as_str()
                .ok_or(anyhow::anyhow!(
                    "Cardano follower config `relay` not a string type".to_string(),
                ))?
                .to_string();

            let mithril_snapshot = serde_json::from_value(
                config
                    .get("mithril_snapshot")
                    .ok_or(anyhow::anyhow!(
                        "Cardano follower config does not have `mithril_snapshot` property"
                            .to_string(),
                    ))?
                    .clone(),
            )?;

            follower_configs.push(FollowerConfig {
                network,
                relay,
                mithril_snapshot,
            });
        }

        if follower_configs.is_empty() {
            Err(NotFoundError.into())
        } else {
            Ok(follower_configs)
        }
    }
}

