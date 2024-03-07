//! Config Queries
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use tracing::error;

use crate::event_db::{Error, EventDB};

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Config Queries Trait
pub(crate) trait ConfigQueries: Sync + Send + 'static {
    async fn get_config(&self) -> Result<(Vec<NetworkMeta>, FollowerMeta), Error>;
}
use crate::event_db::Error::JsonParseIssue;

#[derive(Serialize, Deserialize, Debug, PartialEq, PartialOrd, Clone)]
/// Network config metadata
pub(crate) struct NetworkMeta {
    /// Mainnet, preview, preprod
    pub network: String,
    /// Cardano relay address
    pub relay: String,
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Clone)]
/// Follower metadata
pub(crate) struct FollowerMeta {
    /// Path to snapshot file for bootstrap
    pub mithril_snapshot_path: String,
    /// Defines when data is stale or not
    pub timing_pattern: u8,
}

#[async_trait]
impl ConfigQueries for EventDB {
    async fn get_config(&self) -> Result<(Vec<NetworkMeta>, FollowerMeta), Error> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(
                include_str!("../../../event-db/queries/config/select_config.sql"),
                &[],
            )
            .await?;

        let Some(row) = rows.first() else {
            return Err(Error::NoConfig);
        };

        let mut networks: Vec<String> = Vec::new();

        let follower_meta: String = row.try_get("follower")?;
        let follower_metadata: FollowerMeta =
            serde_json::from_str(&follower_meta).map_err(|e| {
                Error::NotFound(JsonParseIssue(format!("issue parsing db json {e}")).to_string())
            })?;

        row.try_get("cardano")
            .map(|network| networks.push(network))
            .ok();

        row.try_get("preview")
            .map(|network| networks.push(network))
            .ok();

        let mut parse_errors = vec![];

        let network_metadata: Vec<NetworkMeta> = networks
            .iter()
            .map(|meta| serde_json::from_str(meta))
            .filter_map(|r| r.map_err(|e| parse_errors.push(e)).ok())
            .collect();

        if !parse_errors.is_empty() {
            error!("Parsing errors {:?}", parse_errors);
            return Err(Error::JsonParseIssue("Unable to parse config".to_string()));
        }

        Ok((network_metadata, follower_metadata))
    }
}
