//! Configuration Key

use std::{net::IpAddr, sync::LazyLock};

use serde_json::Value;
use tracing::error;

/// Configuration key
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum ConfigKey {
    /// Frontend general configuration.
    Frontend,
    /// Frontend configuration for a specific IP address.
    FrontendForIp(IpAddr),
}

/// Frontend schema configuration.
static FRONTEND_SCHEMA: LazyLock<Option<Value>> =
    LazyLock::new(|| load_json_lazy(include_str!("jsonschema/frontend.json")));

/// Frontend default configuration.
static FRONTEND_DEFAULT: LazyLock<Option<Value>> =
    LazyLock::new(|| load_json_lazy(include_str!("default/frontend.json")));

/// Helper function to convert a JSON string to a JSON value.
fn load_json_lazy(data: &str) -> Option<Value> {
    let json = serde_json::from_str(data);

    json.inspect_err(|e| error!("Error parsing JSON : {e}"))
        .ok()
}

impl ConfigKey {
    /// Convert a `ConfigKey` to its corresponding IDs.
    pub(super) fn to_id(&self) -> (String, String, String) {
        match self {
            ConfigKey::Frontend => ("frontend".to_string(), String::new(), String::new()),
            ConfigKey::FrontendForIp(ip) => {
                ("frontend".to_string(), "ip".to_string(), ip.to_string())
            },
        }
    }

    /// Validate the provided value against the JSON schema.
    pub(super) fn validate(&self, value: &Value) -> anyhow::Result<()> {
        // Retrieve the schema based on ConfigKey
        let schema = match self {
            ConfigKey::Frontend | ConfigKey::FrontendForIp(_) => &*FRONTEND_SCHEMA,
        };

        let Some(schema) = schema else {
            return Err(anyhow::anyhow!("Failed to retrieve JSON schema"));
        };
        let validator = jsonschema::validator_for(schema)
            .map_err(|e| anyhow::anyhow!("Failed to create JSON validator: {:?}", e))?;

        // Validate the value against the schema
        anyhow::ensure!(validator.is_valid(value), "Invalid configuration");
        Ok(())
    }

    /// Retrieve the default configuration value.
    pub(super) fn default(&self) -> Option<Value> {
        // Retrieve the default value based on the ConfigKey
        let default = match self {
            ConfigKey::Frontend | ConfigKey::FrontendForIp(_) => &*FRONTEND_DEFAULT,
        };

        default.clone()
    }
}

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::*;

    #[test]
    fn test_validate() {
        let value = json!({
            "test": "test"
        });
        let result = ConfigKey::Frontend.validate(&value);
        assert!(result.is_ok());
    }

    #[test]
    fn test_default() {
        let result = ConfigKey::Frontend.default();
        assert!(result.is_some());
    }
}
