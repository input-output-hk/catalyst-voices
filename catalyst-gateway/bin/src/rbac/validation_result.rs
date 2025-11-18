//! Types related to validation of new RBAC registrations.

use std::collections::{HashMap, HashSet};

use cardano_chain_follower::StakeAddress;
use catalyst_types::{catalyst_id::CatalystId, uuid::UuidV4};
use ed25519_dalek::VerifyingKey;

/// A return value of the `validate_rbac_registration` method.
pub type RbacValidationResult = anyhow::Result<Option<RbacValidationSuccess>>;

/// A value returned from the `validate_rbac_registration` on happy path.
///
/// It contains information for updating `rbac_registration`,
/// `catalyst_id_for_public_key`, `catalyst_id_for_stake_address` and
/// `catalyst_id_for_txn_id` tables.
pub struct RbacValidationSuccess {
    /// A Catalyst ID of the chain this registration belongs to.
    pub catalyst_id: CatalystId,
    /// A list of stake addresses that were added to the chain.
    pub stake_addresses: HashSet<StakeAddress>,
    /// A list of role signing public keys used in this registration.
    pub public_keys: HashSet<VerifyingKey>,
    /// A list of updates to other chains containing Catalyst IDs and removed stake
    /// addresses.
    ///
    /// A new RBAC registration can take ownership of stake addresses of other chains.
    pub modified_chains: HashMap<CatalystId, HashSet<StakeAddress>>,
    /// A registration purpose.
    pub purpose: Option<UuidV4>,
}
