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
    /// - A JSON value of the configuration, if not found or error, returns the default
    ///   value.
    /// - Error if the query fails.
    pub(crate) async fn get(id: ConfigKey) -> anyhow::Result<Value> {
        let (id1, id2, id3) = id.to_id();
        let row = EventDB::query_one(GET_CONFIG, &[&id1, &id2, &id3]).await?;

        let value = row.get(0);
        Ok(value)
    }

    /// Set the configuration for the given `ConfigKey`.
    ///
    /// # Returns
    ///
    /// - A `BasicOutput` of the validation result, which can be valid or invalid.
    /// - Error if the query fails.
    pub(crate) async fn set(id: ConfigKey, value: Value) -> anyhow::Result<()> {
        let (id1, id2, id3) = id.to_id();
        EventDB::query(UPSERT_CONFIG, &[&id1, &id2, &id3, &value]).await?;
        Ok(())
    }
}
