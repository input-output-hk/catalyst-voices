//! Configuration Key

use std::net::IpAddr;

use serde_json::Value;

/// Configuration key
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum ConfigKey {
    /// Frontend general configuration
    Frontend,
    /// Frontend configuration for a specific IP address
    FrontendForIp(IpAddr),
}

/// Frontend JSON schema
const FRONTEND_JSON_SCHEMA: &str = include_str!("jsonschema/frontend.json");
/// Default frontend configuration
const FRONTEND_DEFAULT: &str = include_str!("default/frontend.json");

impl ConfigKey {
    /// Create a `ConfigKey` from ids.
    pub(crate) fn from_id(id1: &str, id2: &str, id3: &str) -> Option<Self> {
        match (id1, id2, id3) {
            ("frontend", "", "") => Some(ConfigKey::Frontend),
            ("frontend", "ip", ip) => ip.parse().ok().map(ConfigKey::FrontendForIp),
            _ => None,
        }
    }

    /// Convert a `ConfigKey` to its ids.
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
        let schema: Value = serde_json::from_str(FRONTEND_JSON_SCHEMA)
            .map_err(|e| anyhow::anyhow!("Failed to parse JSON schema: {:?}", e))?;

        let validator = jsonschema::validator_for(&schema)
            .map_err(|e| anyhow::anyhow!("Failed to create JSON validator: {:?}", e))?;

        if validator.is_valid(value) {
            Ok(())
        } else {
            Err(anyhow::anyhow!(
                "Provided JSON value does not match the schema for {:?}.",
                self
            ))
        }
    }

    /// Retrieve the default configuration value.
    pub(super) fn default(&self) -> anyhow::Result<Value> {
        let default_value: Value = serde_json::from_str(FRONTEND_DEFAULT)
            .map_err(|e| anyhow::anyhow!("Failed to parse default JSON: {:?}", e))?;

        match self {
            ConfigKey::Frontend | ConfigKey::FrontendForIp(_) => Ok(default_value),
        }
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
        assert!(result.is_ok());
    }
}
