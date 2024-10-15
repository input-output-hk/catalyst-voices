//! Configuration query

use key::ConfigKey;
use serde_json::Value;

use crate::db::event::EventDB;

pub(crate) mod key;

/// Configuration struct
pub(crate) struct Config {}

/// SQL get configuration.
const GET_CONFIG: &str = include_str!("sql/get.sql");
/// SQL update if exist or else insert configuration.
const UPSERT_CONFIG: &str = include_str!("sql/upsert.sql");

impl Config {
    /// Retrieve configuration based on the given `ConfigKey`.
    ///
    /// # Returns
    ///
    /// - A JSON value of the configuration, if not found, returns the default value.
    pub(crate) async fn get(id: ConfigKey) -> anyhow::Result<Value> {
        let (id1, id2, id3) = id.to_id();
        let rows = EventDB::query(GET_CONFIG, &[&id1, &id2, &id3]).await?;

        if let Some(row) = rows.first() {
            let value: Value = row.get(0);
            id.validate(&value).map_err(|e| anyhow::anyhow!(e))?;
            Ok(value)
        } else {
            // If data not found return default config value
            Ok(id.default())
        }
    }

    /// Update or insert (upsert) configuration for the given `ConfigKey`.
    pub(crate) async fn upsert(id: ConfigKey, value: Value) -> anyhow::Result<()> {
        // Validate the value
        id.validate(&value)?;

        let (id1, id2, id3) = id.to_id();
        EventDB::query(UPSERT_CONFIG, &[&id1, &id2, &id3, &value]).await?;

        Ok(())
    }
}
