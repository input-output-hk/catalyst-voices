//! Defines API schemas of stake amount type.

use poem_openapi::{types::Example, Object};

use crate::service::api::cardano::types::{SlotNumber, StakeAmount};

/// User's cardano stake info.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct StakeInfo {
    /// Total stake amount.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub(crate) amount: StakeAmount,

    /// Block's slot number which contains the latest unspent UTXO.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub(crate) slot_number: SlotNumber,
}

impl Example for StakeInfo {
    fn example() -> Self {
        Self {
            amount: 1,
            slot_number: 5,
        }
    }
}

/// Full user's cardano stake info.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct FullStakeInfo {
    /// Volatile stake information.
    pub(crate) volatile: StakeInfo,
    /// Persistent stake information.
    pub(crate) persistent: StakeInfo,
}

impl Example for FullStakeInfo {
    fn example() -> Self {
        Self {
            volatile: StakeInfo::example(),
            persistent: StakeInfo::example(),
        }
    }
}
