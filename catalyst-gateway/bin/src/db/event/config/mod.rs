//! Configuration query

use jsonschema::BasicOutput;
use key::ConfigKey;
use serde_json::Value;
use tracing::error;

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
        let rows = EventDB::query(GET_CONFIG, &[&id1, &id2, &id3]).await?;

        if let Some(row) = rows.first() {
            let value: Value = row.get(0);
            match id.validate(&value) {
                BasicOutput::Valid(_) => return Ok(value),
                BasicOutput::Invalid(errors) => {
                    // This should not happen, expecting the schema to be valid
                    error!(id=%id, errors=?errors, "Get Config, Schema validation failed, defaulting.");
                },
            }
        }
        // Return the default config value as a fallback
        Ok(id.default())
    }

    /// Set the configuration for the given `ConfigKey`.
    ///
    /// # Returns
    ///
    /// - A `BasicOutput` of the validation result, which can be valid or invalid.
    /// - Error if the query fails.
    pub(crate) async fn set(id: ConfigKey, value: Value) -> anyhow::Result<BasicOutput<'static>> {
        let validate = id.validate(&value);
        // Validate schema failed, return immediately with JSON schema error
        if !validate.is_valid() {
            return Ok(validate);
        }

        let (id1, id2, id3) = id.to_id();
        EventDB::query(UPSERT_CONFIG, &[&id1, &id2, &id3, &value]).await?;

        Ok(validate)
    }
}
