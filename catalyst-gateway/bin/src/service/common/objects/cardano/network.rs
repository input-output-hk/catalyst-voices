//! Defines API schemas of Cardano network types.

use poem_openapi::Enum;

/// Cardano network type.
#[derive(Clone, Enum, Debug)]
pub(crate) enum Network {
    /// Cardano mainnet.
    #[oai(rename = "mainnet")]
    Mainnet,
    /// Cardano testnet.
    #[oai(rename = "testnet")]
    Testnet,
    /// Cardano preprod.
    #[oai(rename = "preprod")]
    Preprod,
    /// Cardano preview.
    #[oai(rename = "preview")]
    Preview,
}

impl From<Network> for cardano_chain_follower::Network {
    fn from(value: Network) -> Self {
        match value {
            Network::Mainnet => Self::Mainnet,
            Network::Testnet => Self::Testnet,
            Network::Preprod => Self::Preprod,
            Network::Preview => Self::Preview,
        }
    }
}
