//! Defines API schemas of stake amount type.

use chrono::{DateTime, Utc};
use poem_openapi::{types::Example, Object};

/// Stake amount.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct StakeAmount {
    /// Stake amount.
    pub(crate) amount: u64,

    /// Slot number.
    pub(crate) slot_number: u64,

    /// Date time.
    pub(crate) date_time: DateTime<Utc>,
}

impl Example for StakeAmount {
    fn example() -> Self {
        Self {
            amount: 1,
            slot_number: 5,
            date_time: Utc::now(),
        }
    }
}
