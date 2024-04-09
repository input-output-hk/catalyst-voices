//! Defines API schemas of Cardano sync state types.

use poem_openapi::{types::Example, Object};

use crate::event_db::follower::{BlockHash, DateTime, SlotNumber};

/// Cardano follower's sync state info.
#[derive(Debug, Object)]
#[oai(example = true)]
pub(crate) struct SyncState {
    /// Slot number.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    pub(crate) slot_number: SlotNumber,

    /// Block hash.
    #[oai(validator(min_length = "66", max_length = "66", pattern = "0x[0-9a-f]{64}"))]
    pub(crate) block_hash: BlockHash,

    /// last updated time.
    pub(crate) last_updated: DateTime,
}

impl Example for SyncState {
    fn example() -> Self {
        Self {
            slot_number: 5,
            block_hash: "0x0000000000000000000000000000000000000000000000000000000000000000"
                .to_string(),
            last_updated: chrono::DateTime::default(),
        }
    }
}
