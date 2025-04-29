//! Configuration Key

use std::{fmt::Display, net::IpAddr};

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
}
