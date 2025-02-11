//! Defines API schemas of stake amount type.

use poem_openapi::{types::Example, Object};

use crate::service::{
    api::cardano::types::{SlotNumber, StakeAmount},
    common::types::cardano::{
        asset_name::AssetName, asset_value::AssetValue, hash28::HexEncodedHash28,
    },
};

/// User's staked native token info.
#[derive(Object)]
pub(crate) struct StakedNativeTokenInfo {
    /// Token policy hash.
    pub(crate) policy_hash: HexEncodedHash28,
    /// Token policies Asset Name.
    pub(crate) asset_name: AssetName,
    /// Token Asset Value.
    pub(crate) amount: AssetValue,
}

/// User's cardano stake info.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct StakeInfo {
    /// Total stake amount.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub(crate) ada_amount: StakeAmount,

    /// Block's slot number which contains the latest unspent UTXO.
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
