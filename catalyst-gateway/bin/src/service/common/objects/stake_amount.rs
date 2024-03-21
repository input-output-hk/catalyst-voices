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
    pub(crate) amount: StakeAmount,

    /// Slot number.
    pub(crate) slot_number: SlotNumber,

    /// Block date time.
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
