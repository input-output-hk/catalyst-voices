//! A RBAC registration chain information.

use cardano_chain_follower::{hashes::TransactionId, Slot};
use rbac_registration::registration::cardano::RegistrationChain;

use crate::rbac::stake_address_info::StakeAddressInfo;

/// A RBAC registration chain along with additional information.
pub struct ChainInfo {
    /// A RBAC registration chain.
    pub chain: RegistrationChain,
    /// The latest persistent transaction ID of the chain.
    pub last_persistent_txn: Option<TransactionId>,
    /// The latest volatile transaction ID of the chain.
    pub last_volatile_txn: Option<TransactionId>,
    /// A slot number of the latest persistent registration.
    pub last_persistent_slot: Slot,
    /// A list of stake addresses used in the chain.
    pub stake_addresses: Vec<StakeAddressInfo>,
}
