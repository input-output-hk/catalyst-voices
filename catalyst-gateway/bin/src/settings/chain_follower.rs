//! Command line and environment variable settings for the service

use cardano_chain_follower::Network;
use tracing::info;

use super::str_env_var::StringEnvVar;

/// Default chain to follow.
const DEFAULT_NETWORK: Network = Network::Mainnet;

/// Default number of sync tasks (must be in the range 1 to 255 inclusive.)
const DEFAULT_SYNC_TASKS: u16 = 16;

/// Configuration for the chain follower.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Blockchain we sync from.
    pub(crate) chain: Network,

    /// The maximum number of sync tasks.
    pub(crate) sync_tasks: u16,
}

impl EnvVars {
    /// Create a config for a cassandra cluster, identified by a default namespace.
    pub(super) fn new() -> Self {
        let chain = StringEnvVar::new_as_enum("CHAIN_NETWORK", DEFAULT_NETWORK, false);
        let sync_tasks: u16 = StringEnvVar::new_as(
            "CHAIN_FOLLOWER_SYNC_TASKS",
            DEFAULT_SYNC_TASKS.into(),
            1,
            u16::MAX.into(),
        )
        .try_into()
        .unwrap_or(DEFAULT_SYNC_TASKS);

        Self { chain, sync_tasks }
    }

    /// Log the configuration of this Chain Follower
    pub(crate) fn log(&self) {
        info!(
            chain = self.chain.to_string(),
            sync_tasks = self.sync_tasks,
            "Chain Follower Configuration"
        );
    }
}
