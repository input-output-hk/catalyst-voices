//! `API` Utility operations
pub(crate) mod catch_panic;
pub(crate) mod middleware;

use pallas::ledger::addresses::Network as PallasNetwork;
use poem_openapi::types::ToJSON;

use crate::service::common::objects::{
    cardano::network::Network, validation_error::ValidationError,
};

/// Convert bytes to hex string with the `0x` prefix
pub(crate) fn to_hex_with_prefix(bytes: &[u8]) -> String {
    format!("0x{}", hex::encode(bytes))
}

/// Check the provided network type with the encoded inside the stake address
pub(crate) fn check_network(
    address_network: PallasNetwork, provided_network: Option<Network>,
) -> Result<Network, ValidationError> {
    match address_network {
        PallasNetwork::Mainnet => {
            if let Some(network) = provided_network {
                if !matches!(&network, Network::Mainnet) {
                    return Err(
                        ValidationError::new(
                            format!(
                                "Provided network type {} does not match stake address network type Mainnet",
                                network.to_json_string()
                            )
                        ));
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
                if !matches!(
                    network,
                    Network::Testnet | Network::Preprod | Network::Preview
                ) {
                    return Err(ValidationError::new(
                        format!(
                            "Provided network type {} does not match stake address network type Testnet",
                            network.to_json_string()
                        )
                    ));
                }
                Ok(network)
            } else {
                Ok(Network::Testnet)
            }
        },
        PallasNetwork::Other(x) => Err(ValidationError::new(format!("Unknown network type {x}"))),
    }
}
