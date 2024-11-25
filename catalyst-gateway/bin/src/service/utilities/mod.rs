//! `API` Utility operations
pub(crate) mod catch_panic;
pub(crate) mod convert;
pub(crate) mod middleware;
pub(crate) mod net;

use anyhow::{bail, Result};
// use pallas::ledger::addresses::Network as PallasNetwork;
// use poem_openapi::types::ToJSON;

// use crate::service::common::objects::cardano::network::Network;

/// Convert bytes to hex string with the `0x` prefix
pub(crate) fn as_hex_string(bytes: &[u8]) -> String {
    format!("0x{}", hex::encode(bytes))
}

/// Convert bytes to hex string with the `0x` prefix
pub(crate) fn from_hex_string(hex: &str) -> Result<Vec<u8>> {
    #[allow(clippy::string_slice)] // Safe because of size checks.
    if hex.len() < 4 || hex.len() % 2 != 0 || &hex[0..2] != "0x" {
        bail!("Invalid hex string");
    }

    #[allow(clippy::string_slice)] // Safe due to above checks.
    Ok(hex::decode(&hex[2..])?)
}

/// Unused
const _UNUSED: &str = r#"
/// Network validation error
#[derive(thiserror::Error, Debug)]
pub(crate) enum NetworkValidationError {
    /// Provided network type does not match stake address
    #[error("Provided network type {0} does not match stake address network type {1}")]
    NetworkMismatch(String, String),
    /// Unknown address network type
    #[error("Unknown address network type {0}")]
    UnknownNetwork(u8),
}

/// Check the provided network type with the encoded inside the stake address
pub(crate) fn check_network(
    address_network: PallasNetwork, provided_network: Option<Network>,
) -> anyhow::Result<Network> {
    match address_network {
        PallasNetwork::Mainnet => {
            if let Some(network) = provided_network {
                if !matches!(&network, Network::Mainnet) {
                    return Err(NetworkValidationError::NetworkMismatch(
                        network.to_json_string(),
                        "Mainnet".to_string(),
                    )
                    .into());
                }
            }
            Ok(Network::Mainnet)
        },
        PallasNetwork::Testnet => {
            // the preprod and preview network types are encoded as `testnet` in the stake
            // address, so here we are checking if the `provided_network` type matches the
            // one, and if not - we return an error.
            // if the `provided_network` omitted - we return the `testnet` network type
            if let Some(network) = provided_network {
                if !matches!(network, Network::Preprod | Network::Preview) {
                    return Err(NetworkValidationError::NetworkMismatch(
                        network.to_json_string(),
                        "Testnet".to_string(),
                    )
                    .into());
                }
                Ok(network)
            } else {
                Ok(Network::Preprod)
            }
        },
        PallasNetwork::Other(x) => Err(NetworkValidationError::UnknownNetwork(x).into()),
    }
}
"#;
