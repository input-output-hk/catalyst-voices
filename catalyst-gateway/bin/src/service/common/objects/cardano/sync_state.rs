//! Defines API schemas of Cardano sync state types.

use poem_openapi::{types::Example, Object};

use crate::service::{
    api::cardano::types::{DateTime, SlotNumber},
    common::objects::cardano::hash::Hash,
};

/// Cardano follower's sync state info.
#[derive(Debug, Object)]
#[oai(example = true)]
pub(crate) struct SyncState {
    /// Slot number.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    pub(crate) slot_number: SlotNumber,

    /// Block hash.
    pub(crate) block_hash: Hash,

    /// last updated time.
    pub(crate) last_updated: DateTime,
}

impl Example for SyncState {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self {
            slot_number: 5,
            block_hash: hex::decode(
                "0000000000000000000000000000000000000000000000000000000000000000",
            )
            .expect("Invalid hex")
            .into(),
            last_updated: chrono::DateTime::default(),
        }
    }
}
