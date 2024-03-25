//! Defines API schemas of Cardano network types.

use poem_openapi::Enum;

/// Cardano network type.
#[derive(Enum, Debug)]
pub(crate) enum Network {
    /// Cardano mainnet.
    Mainnet,
    /// Cardano testnet.
    Testnet,
    /// Cardano preprod.
    Preprod,
    /// Cardano preview.
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
