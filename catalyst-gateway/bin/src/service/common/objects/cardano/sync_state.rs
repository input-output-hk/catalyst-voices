//! Defines API schemas of Cardano sync state types.

use chrono::{DateTime, Utc};
use poem_openapi::{types::Example, Object};

use crate::service::common::{objects::cardano::hash::Hash, types::cardano::slot_no::SlotNo};

/// Cardano follower's sync state info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct SyncState {
    /// Slot number.
    pub(crate) slot_number: SlotNo,

    /// Block hash.
    pub(crate) block_hash: Hash,

    /// last updated time.
    pub(crate) last_updated: DateTime<Utc>,
}

impl Example for SyncState {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self {
            slot_number: SlotNo::example(),
            block_hash: hex::decode(
                "0000000000000000000000000000000000000000000000000000000000000000",
            )
            .expect("Invalid hex")
            .into(),
            last_updated: chrono::DateTime::default(),
        }
    }
}
