//! Defines API schemas of Cardano Slot info types.

use poem_openapi::{types::Example, Object};

use crate::service::{
    api::cardano::types::{DateTime, SlotNumber},
    common::objects::cardano::hash::Hash,
};

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
    pub(crate) block_hash: Hash,

    /// Block time.
    pub(crate) block_time: DateTime,
}

impl Example for Slot {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self {
            slot_number: 121_099_410,
            block_hash: hex::decode(
                "aa34657bf91e04eb5b506d76a66f688dbfbc509dbf70bc38124d4e8832fdd68a",
            )
            .expect("Invalid hex")
            .into(),
            block_time: chrono::DateTime::from_timestamp(1_712_676_501, 0)
                .expect("Invalid timestamp"),
        }
    }
}

/// Cardano follower's slot info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct SlotInfo {
    /// Previous slot info.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) previous: Option<Slot>,

    /// Current slot info.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) current: Option<Slot>,

    /// Next slot info.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) next: Option<Slot>,
}

impl Example for SlotInfo {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self {
            previous: Some(Slot {
                slot_number: 121_099_406,
                block_hash: hex::decode(
                    "162ae0e2d08dd238233308eef328bf39ba529b82bc0b87c4eeea3c1dae4fc877",
                )
                .expect("Invalid hex")
                .into(),
                block_time: chrono::DateTime::from_timestamp(1_712_676_497, 0)
                    .expect("Invalid timestamp"),
            }),
            current: Some(Slot {
                slot_number: 121_099_409,
                block_hash: hex::decode(
                    "aa34657bf91e04eb5b506d76a66f688dbfbc509dbf70bc38124d4e8832fdd68a",
                )
                .expect("Invalid hex")
                .into(),
                block_time: chrono::DateTime::from_timestamp(1_712_676_501, 0)
                    .expect("Invalid timestamp"),
            }),
            next: Some(Slot {
                slot_number: 121_099_422,
                block_hash: hex::decode(
                    "83ad63288ae14e75de1a1f794bda5d317fa59cbdbf1cc4dc83471d76555a5e89",
                )
                .expect("Invalid hex")
                .into(),
                block_time: chrono::DateTime::from_timestamp(1_712_676_513, 0)
                    .expect("Invalid timestamp"),
            }),
        }
    }
}
