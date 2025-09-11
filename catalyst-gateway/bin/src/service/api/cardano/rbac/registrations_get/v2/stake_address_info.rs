//! An information about stake address used in a RBAC registration chain.

use poem_openapi::types::Example;
use poem_openapi_derive::Object;

use crate::{
    rbac::StakeAddressInfo,
    service::common::types::cardano::{cip19_stake_address::Cip19StakeAddress, slot_no::SlotNo},
};

/// An information about stake address used in a RBAC registration chain.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub struct RbacStakeAddressInfo {
    /// A stake address.
    stake: Cip19StakeAddress,
    /// A slot number when the registration chain started to use the stake address.
    active_from: SlotNo,
    /// A slot number when the registration chain stopped to use the stake address.
    #[oai(skip_serializing_if_is_empty)]
    inactive_from: Option<SlotNo>,
}

impl From<StakeAddressInfo> for RbacStakeAddressInfo {
    fn from(info: StakeAddressInfo) -> Self {
        Self {
            stake: info.stake.into(),
            active_from: info.active.into(),
            inactive_from: info.inactive.map(Into::into),
        }
    }
}

impl Example for RbacStakeAddressInfo {
    fn example() -> Self {
        Self {
            stake: Cip19StakeAddress::example(),
            active_from: SlotNo::example(),
            inactive_from: Some(SlotNo::example()),
        }
    }
}
