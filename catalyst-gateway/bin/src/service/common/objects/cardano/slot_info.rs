//! Defines API schemas of Cardano Slot info types.

use poem_openapi::{types::Example, Object};

use crate::event_db::follower::{BlockHash, DateTime, SlotNumber};

/// Cardano block's slot data.
#[derive(Object)]
#[oai(example = true)]
#[allow(clippy::struct_field_names)]
pub(crate) struct Slot {
    /// Slot number.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub(crate) slot_number: SlotNumber,

    /// Block hash.
    #[oai(validator(min_length = "66", max_length = "66", pattern = "0x[0-9a-f]{64}"))]
    pub(crate) block_hash: BlockHash,

    /// Block time.
    pub(crate) block_time: DateTime,
}

impl Example for Slot {
    fn example() -> Self {
        Self {
            slot_number: 5,
            block_hash: "0x0000000000000000000000000000000000000000000000000000000000000000"
                .parse()
                .unwrap(),
            block_time: chrono::DateTime::default(),
        }
    }
}

/// Cardano follower's slot info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct SlotInfo {
    /// Current slot info.
    pub(crate) current: Option<Slot>,

    /// Next slot info.
    pub(crate) next: Option<Slot>,
}

impl Example for SlotInfo {
    fn example() -> Self {
        Self {
            current: Some(Slot::example()),
            next: Some(Slot::example()),
        }
    }
}
