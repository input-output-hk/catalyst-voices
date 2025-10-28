//! Command line and environment variable settings for the service

use std::{cmp::min, time::Duration};

use cardano_chain_follower::{turbo_downloader::DlConfig, ChainSyncConfig, Network};
use tracing::info;

use super::str_env_var::{StringEnvVar, StringEnvVarParams};

/// Default chain to follow.
const DEFAULT_NETWORK: NetworkFromStr = NetworkFromStr::Mainnet;

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

/// A default devnet genesis key.
const DEFAULT_DEVNET_GENESIS_KEY: &str = "5b33322c3235332c3138362c3230312c3137372c31312c3131372c3133352c3138372c3136372c3138312c3138382c32322c35392c3230362c3130352c3233312c3135302c3231352c33302c37382c3231322c37362c31362c3235322c3138302c37322c3133342c3133372c3234372c3136312c36385d";

/// A default devnet Cardano networking magic number.
const DEFAULT_DEVNET_MAGIC: u64 = 42;

/// A default devnet Cardano networking identifier.
const DEFAULT_DEVNET_NETWORK_ID: u64 = 42;

/// A default devnet byron epoch length.
const DEFAULT_DEVNET_BYRON_EPOCH_LENGTH: u32 = 100_000;

/// A default devnet byron slot length.
const DEFAULT_DEVNET_BYRON_SLOT_LENGTH: u32 = 1000;

/// A default devnet byron known slot.
const DEFAULT_DEVNET_BYRON_KNOWN_SLOT: u64 = 0;

/// A default devnet byron known time.
const DEFAULT_DEVNET_BYRON_KNOWN_TIME: u64 = 1_564_010_416;

/// A default devnet byron known hash.
const DEFAULT_DEVNET_BYRON_KNOWN_HASH: &str =
    "8f8602837f7c6f8b8867dd1cbc1842cf51a27eaed2c70ef48325d00f8efb320f";

/// A default devnet shelley epoch length.
const DEFAULT_DEVNET_SHELLEY_EPOCH_LENGTH: u32 = 100;

/// A default devnet shelley slot length.
const DEFAULT_DEVNET_SHELLEY_SLOT_LENGTH: u32 = 1;

/// A default devnet shelley known slot.
const DEFAULT_DEVNET_SHELLEY_KNOWN_SLOT: u64 = 1_598_400;

/// A default devnet shelley known hash.
const DEFAULT_DEVNET_SHELLEY_KNOWN_HASH: &str =
    "02b1c561715da9e540411123a6135ee319b02f60b9a11a603d3305556c04329f";

/// A default devnet shelley known time.
const DEFAULT_DEVNET_SHELLEY_KNOWN_TIME: u64 = 1_595_967_616;

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

#[derive(strum::EnumString, strum::VariantNames, strum::Display)]
#[strum(ascii_case_insensitive)]
enum NetworkFromStr {
    /// Mainnet
    Mainnet,
    /// Preprod
    Preprod,
    /// Preview
    Preview,
    /// Devnet
    Devnet,
}

impl From<NetworkFromStr> for Network {
    #[allow(clippy::too_many_lines)]
    fn from(value: NetworkFromStr) -> Self {
        match value {
            NetworkFromStr::Mainnet => Self::Mainnet,
            NetworkFromStr::Preprod => Self::Preprod,
            NetworkFromStr::Preview => Self::Preview,
            NetworkFromStr::Devnet => {
                let genesis_key = StringEnvVar::new(
                    "CHAIN_FOLLOWER_DEVNET_GENESIS_KEY",
                    StringEnvVarParams::Plain(
                        "DEFAULT_DEVNET_GENESIS_KEY".into(),
                        DEFAULT_DEVNET_GENESIS_KEY.to_string().into(),
                    ),
                );
                let magic = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_MAGIC",
                    DEFAULT_DEVNET_MAGIC,
                    0,
                    u64::MAX,
                );
                let network_id = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_NETWORK_ID",
                    DEFAULT_DEVNET_NETWORK_ID,
                    0,
                    u64::MAX,
                );
                let byron_epoch_length = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_BYRON_EPOCH_LENGTH",
                    DEFAULT_DEVNET_BYRON_EPOCH_LENGTH,
                    0,
                    u32::MAX,
                );
                let byron_slot_length = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_BYRON_SLOT_LENGTH",
                    DEFAULT_DEVNET_BYRON_SLOT_LENGTH,
                    0,
                    u32::MAX,
                );
                let byron_known_slot = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_BYRON_KNOWN_SLOT",
                    DEFAULT_DEVNET_BYRON_KNOWN_SLOT,
                    0,
                    u64::MAX,
                );
                let byron_known_hash = StringEnvVar::new(
                    "CHAIN_FOLLOWER_DEVNET_BYRON_KNOWN_HASH",
                    StringEnvVarParams::Plain(
                        "DEFAULT_DEVNET_BYRON_KNOWN_HASH".into(),
                        DEFAULT_DEVNET_BYRON_KNOWN_HASH.to_string().into(),
                    ),
                );
                let byron_known_time = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_BYRON_KNOWN_TIME",
                    DEFAULT_DEVNET_BYRON_KNOWN_TIME,
                    0,
                    u64::MAX,
                );
                let shelley_epoch_length = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_SHELLEY_EPOCH_LENGTH",
                    DEFAULT_DEVNET_SHELLEY_EPOCH_LENGTH,
                    0,
                    u32::MAX,
                );
                let shelley_slot_length = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_SHELLEY_SLOT_LENGTH",
                    DEFAULT_DEVNET_SHELLEY_SLOT_LENGTH,
                    0,
                    u32::MAX,
                );
                let shelley_known_slot = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_SHELLEY_KNOWN_SLOT",
                    DEFAULT_DEVNET_SHELLEY_KNOWN_SLOT,
                    0,
                    u64::MAX,
                );
                let shelley_known_hash = StringEnvVar::new(
                    "CHAIN_FOLLOWER_DEVNET_SHELLEY_KNOWN_HASH",
                    StringEnvVarParams::Plain(
                        "DEFAULT_DEVNET_SHELLEY_KNOWN_HASH".into(),
                        DEFAULT_DEVNET_SHELLEY_KNOWN_HASH.to_string().into(),
                    ),
                );
                let shelley_known_time = StringEnvVar::new_as_int(
                    "CHAIN_FOLLOWER_DEVNET_SHELLEY_KNOWN_TIME",
                    DEFAULT_DEVNET_SHELLEY_KNOWN_TIME,
                    0,
                    u64::MAX,
                );

                Self::Devnet {
                    genesis_key: genesis_key.as_string(),
                    magic,
                    network_id,
                    byron_epoch_length,
                    byron_slot_length,
                    byron_known_slot,
                    byron_known_hash: byron_known_hash.as_string(),
                    byron_known_time,
                    shelley_epoch_length,
                    shelley_slot_length,
                    shelley_known_slot,
                    shelley_known_hash: shelley_known_hash.as_string(),
                    shelley_known_time,
                }
            },
        }
    }
}

impl EnvVars {
    /// Create a config for a cassandra cluster, identified by a default namespace.
    pub(super) fn new() -> Self {
        let chain: Network =
            StringEnvVar::new_as_enum("CHAIN_NETWORK", DEFAULT_NETWORK, false).into();

        let sync_tasks: u16 = StringEnvVar::new_as_int(
            "CHAIN_FOLLOWER_SYNC_TASKS",
            DEFAULT_SYNC_TASKS,
            1,
            MAX_SYNC_TASKS,
        );

        let sync_slots: u64 = StringEnvVar::new_as_int(
            "CHAIN_FOLLOWER_SYNC_MAX_SLOTS",
            DEFAULT_SYNC_MAX_SLOTS,
            MIN_SYNC_MAX_SLOTS,
            MAX_SYNC_MAX_SLOTS,
        );

        let cfg = ChainSyncConfig::default_for(chain.clone());
        let mut dl_config = cfg.mithril_cfg.dl_config.clone().unwrap_or_default();

        let workers = StringEnvVar::new_as_int(
            "CHAIN_FOLLOWER_DL_CONNECTIONS",
            dl_config.workers,
            1,
            MAX_DL_CONNECTIONS,
        );
        dl_config = dl_config.with_workers(workers);

        let default_dl_chunk_size = min(1, dl_config.chunk_size / ONE_MEGABYTE);

        let chunk_size = StringEnvVar::new_as_int(
            "CHAIN_FOLLOWER_DL_CHUNK_SIZE",
            default_dl_chunk_size,
            1,
            MAX_DL_CHUNK_SIZE,
        )
            .checked_mul(ONE_MEGABYTE)
            .unwrap_or_else(|| {
                info!("Too big 'CHAIN_FOLLOWER_DL_CHUNK_SIZE' value, default value {default_dl_chunk_size} is used");
                default_dl_chunk_size
            });
        dl_config = dl_config.with_chunk_size(chunk_size);

        let queue_ahead = StringEnvVar::new_as_int(
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
        let dl_connect_timeout = StringEnvVar::new_as_int(
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
        let dl_data_timeout = StringEnvVar::new_as_int(
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
