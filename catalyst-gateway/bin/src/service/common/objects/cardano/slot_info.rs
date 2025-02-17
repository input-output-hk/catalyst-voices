//! Defines API schemas of Cardano Slot info types.

use derive_more::{From, Into};
use poem_openapi::{types::Example, NewType, Object};

use crate::service::common::{
    objects::cardano::hash::Hash256,
    types::{cardano::slot_no::SlotNo, generic::date_time::DateTime},
};

/// Cardano block's slot data.
#[derive(Object)]
#[oai(example = true)]
#[allow(clippy::struct_field_names)]
pub(crate) struct Slot {
    /// Slot number.
    pub(crate) slot_number: SlotNo,

    /// Block hash.
    pub(crate) block_hash: Hash256,

    /// Block time.
    pub(crate) block_time: DateTime,
}

impl Example for Slot {
    fn example() -> Self {
        Self {
            slot_number: SlotNo::example(),
            block_hash: Hash256::example(),
            block_time: DateTime::example(),
        }
    }
}

/// Previous slot info.
#[derive(NewType, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct PreviousSlot(Slot);

impl Example for PreviousSlot {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self(Slot {
            slot_number: 121_099_406u64.try_into().unwrap_or_default(),
            block_hash: hex::decode(
                "162ae0e2d08dd238233308eef328bf39ba529b82bc0b87c4eeea3c1dae4fc877",
            )
            .expect("Invalid hex")
            .into(),
            block_time: chrono::DateTime::from_timestamp(1_712_676_497, 0)
                .expect("Invalid timestamp")
                .into(),
        })
    }
}

/// Current slot info.
#[derive(NewType, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct CurrentSlot(Slot);

impl Example for CurrentSlot {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self(Slot {
            slot_number: 121_099_409u64.try_into().unwrap_or_default(),
            block_hash: hex::decode(
                "aa34657bf91e04eb5b506d76a66f688dbfbc509dbf70bc38124d4e8832fdd68a",
            )
            .expect("Invalid hex")
            .into(),
            block_time: chrono::DateTime::from_timestamp(1_712_676_501, 0)
                .expect("Invalid timestamp")
                .into(),
        })
    }
}

/// Next slot info.
#[derive(NewType, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct NextSlot(Slot);

impl Example for NextSlot {
    #[allow(clippy::expect_used)]
    fn example() -> Self {
        Self(Slot {
            slot_number: 121_099_422u64.try_into().unwrap_or_default(),
            block_hash: hex::decode(
                "83ad63288ae14e75de1a1f794bda5d317fa59cbdbf1cc4dc83471d76555a5e89",
            )
            .expect("Invalid hex")
            .into(),
            block_time: chrono::DateTime::from_timestamp(1_712_676_513, 0)
                .expect("Invalid timestamp")
                .into(),
        })
    }
}

/// Cardano follower's slot info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct SlotInfo {
    /// Previous slot info.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) previous: Option<PreviousSlot>,

    /// Current slot info.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) current: Option<CurrentSlot>,

    /// Next slot info.
    #[oai(skip_serializing_if_is_none)]
    pub(crate) next: Option<NextSlot>,
}

impl Example for SlotInfo {
    fn example() -> Self {
        Self {
            previous: Some(Example::example()),
            current: Some(Example::example()),
            next: Some(Example::example()),
        }
    }
}
