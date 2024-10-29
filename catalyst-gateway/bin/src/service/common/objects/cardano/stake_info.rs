//! Defines API schemas of stake amount type.

use poem_openapi::{types::Example, Object};

use crate::service::api::cardano::types::{SlotNumber, StakeAmount};

/// User's staked native token info.
#[derive(Object)]
pub(crate) struct StakedNativeTokenInfo {
    /// Token policy hash.
    #[oai(validator(max_length = "256", pattern = "^0x[a-f0-9]+$"))]
    pub(crate) policy_hash: String,
    /// Token policy name.
    #[oai(validator(max_length = "256", pattern = ".*"))]
    pub(crate) policy_name: String,
    /// Token amount.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub(crate) amount: StakeAmount,
}

/// User's cardano stake info.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct StakeInfo {
    /// Total stake amount.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub(crate) ada_amount: StakeAmount,

    /// Block's slot number which contains the latest unspent UTXO.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub(crate) slot_number: SlotNumber,

    /// Native token infos.
    #[oai(validator(max_items = "1000"))]
    pub(crate) native_tokens: Vec<StakedNativeTokenInfo>,
}

impl Example for StakeInfo {
    fn example() -> Self {
        Self {
            slot_number: 5,
            ada_amount: 1,
            native_tokens: Vec::new(),
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
