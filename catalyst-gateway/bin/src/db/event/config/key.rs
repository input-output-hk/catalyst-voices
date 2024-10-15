//! Configuration Key

use std::{net::IpAddr, sync::LazyLock};

use jsonschema::Validator;
use serde_json::{json, Value};
use tracing::error;

/// Configuration key
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum ConfigKey {
    /// Frontend general configuration.
    Frontend,
    /// Frontend configuration for a specific IP address.
    FrontendForIp(IpAddr),
}

/// Frontend schema validator.
static FRONTEND_SCHEMA_VALIDATOR: LazyLock<Validator> =
    LazyLock::new(|| schema_validator(&load_json_lazy(include_str!("jsonschema/frontend.json"))));

/// Frontend default configuration.
static FRONTEND_DEFAULT: LazyLock<Value> =
    LazyLock::new(|| load_json_lazy(include_str!("default/frontend.json")));

/// Helper function to create a JSON validator from a JSON schema.
/// If the schema is invalid, a default JSON validator is created.
fn schema_validator(schema: &Value) -> Validator {
    jsonschema::validator_for(schema).unwrap_or_else(|e| {
        error!("Error creating JSON validator: {}", e);

        // Create a default JSON validator as a fallback
        // This should not fail since it is hard coded
        #[allow(clippy::expect_used)]
        Validator::new(&json!({
            "$schema": "http://json-schema.org/draft-07/schema#",
            "type": "object"
        }))
        .expect("Failed to create default JSON validator")
    })
}

/// Helper function to convert a JSON string to a JSON value.
fn load_json_lazy(data: &str) -> Value {
    serde_json::from_str(data).unwrap_or_else(|e| {
        error!("Error parsing JSON: {}", e);
        json!({})
    })
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
        // Retrieve the validator based on ConfigKey
        let validator = match self {
            ConfigKey::Frontend | ConfigKey::FrontendForIp(_) => &*FRONTEND_SCHEMA_VALIDATOR,
        };

        // Validate the value against the schema
        anyhow::ensure!(
            validator.is_valid(value),
            "Invalid JSON, Failed schema validation"
        );
        Ok(())
    }

    /// Retrieve the default configuration value.
    pub(super) fn default(&self) -> Value {
        // Retrieve the default value based on the ConfigKey
        match self {
            ConfigKey::Frontend | ConfigKey::FrontendForIp(_) => FRONTEND_DEFAULT.clone(),
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
        assert!(result.is_object());
    }
}
