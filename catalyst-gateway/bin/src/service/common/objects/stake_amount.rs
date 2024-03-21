//! Defines API schemas of stake amount type.

use chrono::{DateTime, Utc};
use poem_openapi::{types::Example, Object};

/// Stake amount.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct StakeAmount {
    /// Stake amount.
    amount: u64,

    /// Slot number.
    slot_number: u64,

    /// Date time.
    date: DateTime<Utc>,
}

impl Example for StakeAmount {
    fn example() -> Self {
        Self {
            amount: 1,
            slot_number: 5,
            date: Utc::now(),
        }
    }
}
