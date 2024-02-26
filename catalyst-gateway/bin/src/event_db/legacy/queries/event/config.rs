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
pub(crate) struct NetworkMeta {
    pub network: String,
    pub relay: String,
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Clone)]
pub(crate) struct FollowerMeta {
    pub mithril_snapshot_path: String,
    pub timing_pattern: u8,
}

impl EventDB {
    /// Get config
    const CONFIG_QUERY: &'static str = "SELECT cardano, follower, preview FROM config";
}

#[async_trait]
impl ConfigQueries for EventDB {
    async fn get_config(&self) -> Result<(Vec<NetworkMeta>, FollowerMeta), Error> {
        let conn = self.pool.get().await?;

        let rows = conn.query(Self::CONFIG_QUERY, &[]).await?;

        if rows.is_empty() {
            return Err(Error::NoConfig);
        }

        let mut networks: Vec<String> = Vec::new();

        let follower_meta: String = rows[0].try_get("follower")?;
        let follower_metadata: FollowerMeta =
            serde_json::from_str(&follower_meta).map_err(|e| {
                Error::NotFound(JsonParseIssue(format!("issue parsing db json {e}")).to_string())
            })?;

        rows[0]
            .try_get("cardano")
            .map(|network| networks.push(network))
            .ok();

        rows[0]
            .try_get("preview")
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
