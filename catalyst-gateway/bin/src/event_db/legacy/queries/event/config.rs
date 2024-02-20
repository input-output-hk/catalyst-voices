//! Config Queries
use async_trait::async_trait;
use serde::Deserialize;
use serde::Serialize;

use crate::event_db::Error;
use crate::event_db::EventDB;

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Config Queries Trait
pub(crate) trait ConfigQueries: Sync + Send + 'static {
    async fn get_config(&self) -> Result<(Vec<NetworkMeta>, FollowerMeta), Error>;
}

#[derive(Serialize, Deserialize, Debug, PartialEq, PartialOrd)]
pub(crate) struct NetworkMeta {
    pub network: String,
    pub relay: String,
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub(crate) struct FollowerMeta {
    pub mithril_addr: String,
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
        let follower_metadata: FollowerMeta = serde_json::from_str(&follower_meta).unwrap();

        rows[0]
            .try_get("cardano")
            .map(|network| networks.push(network))
            .ok();

        rows[0]
            .try_get("preview")
            .map(|network| networks.push(network))
            .ok();

        let mut errors = vec![];

        let network_metadata: Vec<NetworkMeta> = networks
            .iter()
            .map(|meta| serde_json::from_str(&meta))
            .filter_map(|r| r.map_err(|e| errors.push(e)).ok())
            .collect();

        Ok((network_metadata, follower_metadata))
    }
}
