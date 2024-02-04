//! Config Queries
use async_trait::async_trait;

use crate::event_db::Error;
use crate::event_db::EventDB;

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Config Queries Trait
pub(crate) trait ConfigQueries: Sync + Send + 'static {
    async fn get_config(&self) -> Result<Vec<String>, Error>;
}

impl EventDB {
    /// Get config
    const CONFIG_QUERY: &'static str = "SELECT id, id2, id3 FROM config";
}

#[async_trait]
impl ConfigQueries for EventDB {
    async fn get_config(&self) -> Result<Vec<String>, Error> {
        let conn = self.pool.get().await?;

        let rows = conn.query(Self::CONFIG_QUERY, &[]).await?;

        if rows.is_empty() {
            return Err(Error::NoConfig);
        }

        let mut networks: Vec<String> = Vec::new();

        rows[0]
            .try_get("id")
            .map(|network| networks.push(network))
            .ok();

        rows[0]
            .try_get("id2")
            .map(|network| networks.push(network))
            .ok();

        rows[0]
            .try_get("id3")
            .map(|network| networks.push(network))
            .ok();

        Ok(networks)
    }
}
