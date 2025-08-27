//! The information about a stake address used in RBAC registration chain.

use cardano_chain_follower::{Slot, StakeAddress};

/// The information about a stake address used in RBAC registration chain.
pub struct StakeAddressInfo {
    /// A stake address.
    pub stake: StakeAddress,
    /// A slot number when the stake address becomes active for the registration chain.
    pub active: Slot,
    /// A first slot number when the address is no longer active (it is still used by the
    /// chain in the `inactive - 1` slot).
    pub inactive: Option<Slot>,
}
