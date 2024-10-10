//! Command line and environment variable settings for the service

use std::{cmp::min, time::Duration};

use cardano_chain_follower::{turbo_downloader::DlConfig, ChainSyncConfig, Network};
use tracing::info;

use super::str_env_var::StringEnvVar;

/// Default chain to follow.
const DEFAULT_NETWORK: Network = Network::Mainnet;

/// Default number of sync tasks (must be in the range 1 to 256 inclusive.)
const DEFAULT_SYNC_TASKS: u16 = 16;

/// Maximum number of sync tasks (must be in the range 1 to 256 inclusive.)
const MAX_SYNC_TASKS: u16 = 256;

/// Default number of slots each sync task will process at one time.
/// This default is just over one week worth of data where 1 slot == 1 second.
const DEFAULT_SYNC_MAX_SLOTS: u64 = 700_000;
/// Minimum the number of slots each sync task will process at one time can be set to.
/// Note: This is just the setting minimum, a sync task may sync as few as a 1 slot.
const MIN_SYNC_MAX_SLOTS: u64 = 10_000;
/// Maximum the number of slots each sync task will process at one time can be set to.
const MAX_SYNC_MAX_SLOTS: u64 = 100_000_000;

/// Maximum number of DL Connections (must be in the range 1 to 256 inclusive.)
const MAX_DL_CONNECTIONS: usize = 256;

/// Maximum DL Chunk Size in MB (must be in the range 1 to 256 inclusive.)
const MAX_DL_CHUNK_SIZE: usize = 256;

/// Maximum DL Chunk Queue Ahead (must be in the range 1 to 256 inclusive.)
const MAX_DL_CHUNK_QUEUE_AHEAD: usize = 256;

/// Maximum DL Chunk Connect/Data Timeout in seconds (0 = Disabled).
const MAX_DL_TIMEOUT: u64 = 300;

/// Number of bytes in a Megabyte
const ONE_MEGABYTE: usize = 1_048_576;

/// Configuration for the chain follower.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Blockchain we sync from.
    pub(crate) chain: Network,

    /// The maximum number of sync tasks.
    pub(crate) sync_tasks: u16,

    /// The maximum number of slots a sync task will process at once.
    pub(crate) sync_chunk_max_slots: u64,

    /// The Mithril Downloader Configuration.
    pub(crate) dl_config: DlConfig,
}

impl EnvVars {
    /// Create a config for a cassandra cluster, identified by a default namespace.
    pub(super) fn new() -> Self {
        let chain = StringEnvVar::new_as_enum("CHAIN_NETWORK", DEFAULT_NETWORK, false);
        let sync_tasks: u16 = StringEnvVar::new_as(
            "CHAIN_FOLLOWER_SYNC_TASKS",
            DEFAULT_SYNC_TASKS,
            1,
            MAX_SYNC_TASKS,
        );

        let sync_slots: u64 = StringEnvVar::new_as(
            "CHAIN_FOLLOWER_SYNC_MAX_SLOTS",
            DEFAULT_SYNC_MAX_SLOTS,
            MIN_SYNC_MAX_SLOTS,
            MAX_SYNC_MAX_SLOTS,
        );

        let cfg = ChainSyncConfig::default_for(chain);
        let mut dl_config = cfg.mithril_cfg.dl_config.clone().unwrap_or_default();

        let workers = StringEnvVar::new_as(
            "CHAIN_FOLLOWER_DL_CONNECTIONS",
            dl_config.workers,
            1,
            MAX_DL_CONNECTIONS,
        );
        dl_config = dl_config.with_workers(workers);

        let default_dl_chunk_size = min(1, dl_config.chunk_size / ONE_MEGABYTE);

        let chunk_size = StringEnvVar::new_as(
            "CHAIN_FOLLOWER_DL_CHUNK_SIZE",
            default_dl_chunk_size,
            1,
            MAX_DL_CHUNK_SIZE,
        ) * ONE_MEGABYTE;
        dl_config = dl_config.with_chunk_size(chunk_size);

        let queue_ahead = StringEnvVar::new_as(
            "CHAIN_FOLLOWER_DL_QUEUE_AHEAD",
            dl_config.queue_ahead,
            1,
            MAX_DL_CHUNK_QUEUE_AHEAD,
        );
        dl_config = dl_config.with_queue_ahead(queue_ahead);

        let default_dl_connect_timeout = match dl_config.connection_timeout {
            Some(timeout) => timeout.as_secs(),
            None => 0,
        };
        let dl_connect_timeout = StringEnvVar::new_as(
            "CHAIN_FOLLOWER_DL_CONNECT_TIMEOUT",
            default_dl_connect_timeout,
            0,
            MAX_DL_TIMEOUT,
        );
        if dl_connect_timeout == 0 {
            dl_config.connection_timeout = None;
        } else {
            dl_config = dl_config.with_connection_timeout(Duration::from_secs(dl_connect_timeout));
        }

        let default_dl_data_timeout = match dl_config.data_read_timeout {
            Some(timeout) => timeout.as_secs(),
            None => 0,
        };
        let dl_data_timeout = StringEnvVar::new_as(
            "CHAIN_FOLLOWER_DL_DATA_TIMEOUT",
            default_dl_data_timeout,
            0,
            MAX_DL_TIMEOUT,
        );
        if dl_connect_timeout == 0 {
            dl_config.data_read_timeout = None;
        } else {
            dl_config = dl_config.with_data_read_timeout(Duration::from_secs(dl_data_timeout));
        }

        Self {
            chain,
            sync_tasks,
            sync_chunk_max_slots: sync_slots,
            dl_config,
        }
    }

    /// Log the configuration of this Chain Follower
    pub(crate) fn log(&self) {
        info!(
            chain = self.chain.to_string(),
            sync_tasks = self.sync_tasks,
            dl_config = ?self.dl_config,
            "Chain Follower Configuration"
        );
    }
}
