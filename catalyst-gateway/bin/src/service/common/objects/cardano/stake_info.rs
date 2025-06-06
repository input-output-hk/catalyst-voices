//! Defines API schemas of stake amount type.

use derive_more::{From, Into};
use poem_openapi::{
    types::{Example, ToJSON},
    NewType, Object,
};

use crate::service::common::types::{
    array_types::impl_array_types,
    cardano::{
        ada_value::AdaValue, asset_name::AssetName, asset_value::AssetValue,
        hash28::HexEncodedHash28, slot_no::SlotNo,
    },
};

/// User's staked txo asset info.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub(crate) struct StakedTxoAssetInfo {
    /// Asset policy hash (28 bytes).
    pub(crate) policy_hash: HexEncodedHash28,
    /// Token policies Asset Name.
    pub(crate) asset_name: AssetName,
    /// Token Asset Value.
    pub(crate) amount: AssetValue,
}

impl Example for StakedTxoAssetInfo {
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
    StakedAssetInfoList,
    StakedTxoAssetInfo,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(1000),
        items: Some(Box::new(StakedTxoAssetInfo::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for StakedAssetInfoList {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}

/// User's cardano stake info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct StakeInfo {
    /// Total stake amount.
    pub(crate) ada_amount: AdaValue,

    /// Block's slot number which contains the latest unspent UTXO.
    pub(crate) slot_number: SlotNo,

    /// TXO assets infos.
    pub(crate) assets: StakedAssetInfoList,
}

impl Example for StakeInfo {
    fn example() -> Self {
        Self {
            slot_number: SlotNo::example(),
            ada_amount: AdaValue::example(),
            assets: Vec::new().into(),
        }
    }
}

/// Volatile stake information.
#[derive(NewType, From, Into)]
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
#[derive(NewType, From, Into)]
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
#[derive(Object)]
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
