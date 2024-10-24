//! Configuration Key

use std::{fmt::Display, net::IpAddr, sync::LazyLock};

use jsonschema::{BasicOutput, Validator};
use serde_json::{json, Value};
use tracing::error;

use crate::utils::schema::{extract_json_schema_for, SCHEMA_VERSION};

/// Configuration key
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum ConfigKey {
    /// Frontend general configuration.
    Frontend,
    /// Frontend configuration for a specific IP address.
    FrontendForIp(IpAddr),
}

impl Display for ConfigKey {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ConfigKey::Frontend => write!(f, "config_key_frontend"),
            ConfigKey::FrontendForIp(_) => write!(f, "config_key_frontend_ip"),
        }
    }
}

/// Frontend schema from API specification.
pub(crate) static FRONTEND_SCHEMA: LazyLock<Value> =
    LazyLock::new(|| extract_json_schema_for("FrontendConfig"));

/// Frontend schema validator.
static FRONTEND_SCHEMA_VALIDATOR: LazyLock<Validator> =
    LazyLock::new(|| schema_validator(&FRONTEND_SCHEMA));

/// Frontend default configuration.
static FRONTEND_DEFAULT: LazyLock<Value> =
    LazyLock::new(|| load_json_lazy(include_str!("default/frontend.json")));

/// Frontend specific configuration.
static FRONTEND_IP_DEFAULT: LazyLock<Value> =
    LazyLock::new(|| load_json_lazy(include_str!("default/frontend_ip.json")));

/// Helper function to create a JSON validator from a JSON schema.
/// If the schema is invalid, a default JSON validator is created.
fn schema_validator(schema: &Value) -> Validator {
    Validator::options()
        .with_draft(jsonschema::Draft::Draft202012)
        .build(schema)
        .unwrap_or_else(|err| {
            error!(
                id="schema_validator",
                error=?err,
                "Error creating JSON validator"
            );

            default_validator()
        })
}

/// Create a default JSON validator as a fallback
/// This should not fail since it is hard coded
fn default_validator() -> Validator {
    #[allow(clippy::expect_used)]
    Validator::new(&json!({
        "$schema": SCHEMA_VERSION,
        "type": "object"
    }))
    .expect("Failed to create default JSON validator")
}

/// Helper function to convert a JSON string to a JSON value.
fn load_json_lazy(data: &str) -> Value {
    serde_json::from_str(data).unwrap_or_else(|err| {
        error!(id="load_json_lazy", error=?err, "Error parsing JSON");
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
    pub(super) fn validate(&self, value: &Value) -> BasicOutput<'static> {
        // Retrieve the validator based on ConfigKey
        let validator = match self {
            ConfigKey::Frontend | ConfigKey::FrontendForIp(_) => &*FRONTEND_SCHEMA_VALIDATOR,
        };

        // Validate the value against the schema
        validator.apply(value).basic()
    }

    /// Retrieve the default configuration value.
    pub(super) fn default(&self) -> Value {
        // Retrieve the default value based on the ConfigKey
        match self {
            ConfigKey::Frontend => FRONTEND_DEFAULT.clone(),
            ConfigKey::FrontendForIp(_) => FRONTEND_IP_DEFAULT.clone(),
        }
    }

    /// Retrieve the JSON schema.
    pub(crate) fn schema(&self) -> &Value {
        match self {
            ConfigKey::Frontend | ConfigKey::FrontendForIp(_) => &FRONTEND_SCHEMA,
        }
    }
}

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::*;

    #[test]
    fn test_schema_for_schema() {
        // Invalid schema
        let invalid_schema = json!({
            "title": "Invalid Example Schema",
            "type": "object",

            "properties": {
                "invalidProperty": {
                    "type": "unknownType"
                }
            },

        });
        // This should not fail
        schema_validator(&invalid_schema);
    }

    #[test]
    fn test_valid_validate_1() {
        let value = json!({
            "sentry": {
                "dsn": "https://test.com"
            }
        });
        let result = ConfigKey::Frontend.validate(&value);
        assert!(result.is_valid());
        println!("{:?}", serde_json::to_value(result).unwrap());
    }

    #[test]
    fn test_valid_validate_2() {
        let value = json!({});
        let result = ConfigKey::Frontend.validate(&value);
        assert!(result.is_valid());
        println!("{:?}", serde_json::to_value(result).unwrap());
    }

    #[test]
    fn test_invalid_validate() {
        let value = json!([]);
        let result = ConfigKey::Frontend.validate(&value);
        assert!(!result.is_valid());
        println!("{:?}", serde_json::to_value(result).unwrap());
    }

    #[test]
    fn test_default() {
        let result = ConfigKey::Frontend.default();
        assert!(result.is_object());
    }

    #[test]
    fn test_default_validator() {
        let result = std::panic::catch_unwind(|| {
            default_validator();
        });
        // Assert that no panic occurred
        assert!(result.is_ok(), "default_validator panicked");
    }
}
