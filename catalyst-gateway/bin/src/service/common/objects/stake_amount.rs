//! Defines API schemas of stake amount type.

use chrono::Utc;
use poem_openapi::{types::Example, Object};

use crate::event_db::{
    follower::{BlockTime, SlotNumber},
    utxo::StakeAmount,
};

/// User's cardano stake info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct StakeInfo {
    /// Stake amount.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    pub(crate) amount: StakeAmount,

    /// Slot number.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    pub(crate) slot_number: SlotNumber,

    /// Block date time.
    #[oai(validator(max_length = "30"))]
    pub(crate) block_time: BlockTime,
}

impl Example for StakeInfo {
    fn example() -> Self {
        Self {
            amount: 1,
            slot_number: 5,
            block_time: Utc::now(),
        }
    }
}
