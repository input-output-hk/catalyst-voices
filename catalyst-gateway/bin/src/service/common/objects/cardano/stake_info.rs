//! Defines API schemas of stake amount type.

use derive_more::{From, Into};
use poem_openapi::{
    types::{Example, ToJSON},
    NewType, Object,
};

use crate::service::common::types::{
    array_types::impl_array_types,
    cardano::{
        asset_name::AssetName, asset_value::AssetValue, hash28::HexEncodedHash28, slot_no::SlotNo,
        stake_amount::StakeAmount,
    },
};

/// User's staked native token info.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub(crate) struct StakedNativeTokenInfo {
    /// Token policy hash.
    pub(crate) policy_hash: HexEncodedHash28,
    /// Token policies Asset Name.
    pub(crate) asset_name: AssetName,
    /// Token Asset Value.
    pub(crate) amount: AssetValue,
}

impl Example for StakedNativeTokenInfo {
    fn example() -> Self {
        Self {
            policy_hash: Example::example(),
            asset_name: Example::example(),
            amount: Example::example(),
        }
    }
}

// List of User's Staked Native Token Info
impl_array_types!(
    StakedNativeTokenInfoList,
    StakedNativeTokenInfo,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(1000),
        items: Some(Box::new(StakedNativeTokenInfo::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for StakedNativeTokenInfoList {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}

/// User's cardano stake info.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct StakeInfo {
    /// Total stake amount.
    pub(crate) ada_amount: StakeAmount,

    /// Block's slot number which contains the latest unspent UTXO.
    pub(crate) slot_number: SlotNo,

    /// Native token infos.
    pub(crate) native_tokens: StakedNativeTokenInfoList,
}

impl Example for StakeInfo {
    fn example() -> Self {
        Self {
            slot_number: 5u64.try_into().unwrap_or_default(),
            ada_amount: 1u64.try_into().unwrap_or_default(),
            native_tokens: Example::example(),
        }
    }
}

/// Volatile stake information.
#[derive(NewType, Default, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct VolatileStakeInfo(StakeInfo);

impl Example for VolatileStakeInfo {
    fn example() -> Self {
        Self(Example::example())
    }
}

/// Persistent stake information.
#[derive(NewType, Default, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct PersistentStakeInfo(StakeInfo);

impl Example for PersistentStakeInfo {
    fn example() -> Self {
        Self(Example::example())
    }
}

/// Full user's cardano stake info.
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct FullStakeInfo {
    /// Volatile stake information.
    pub(crate) volatile: VolatileStakeInfo,
    /// Persistent stake information.
    pub(crate) persistent: PersistentStakeInfo,
}

impl Example for FullStakeInfo {
    fn example() -> Self {
        Self {
            volatile: Example::example(),
            persistent: Example::example(),
        }
    }
}
