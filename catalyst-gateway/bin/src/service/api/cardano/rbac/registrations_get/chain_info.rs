//! A RBAC registration chain information.

use cardano_blockchain_types::{Slot, TransactionId};
use rbac_registration::registration::cardano::RegistrationChain;

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
}

impl ChainInfo {
    /// Creates a new `ChainInfo` instance.
    pub(crate) fn new(
        persistent_chain: Option<RegistrationChain>, volatile_chain: Option<RegistrationChain>,
    ) -> Option<Self> {
        let mut chain = None;
        let mut last_persistent_txn = None;
        let mut last_volatile_txn = None;
        // TODO: FIXME:
        let mut last_persistent_slot = 0.into();

        if let Some(c) = persistent_chain {
            last_persistent_txn = Some(c.current_tx_id_hash());
            chain = Some(c);
        };
        if let Some(c) = volatile_chain {
            last_volatile_txn = Some(c.current_tx_id_hash());
            chain = Some(c);
        };

        let Some(chain) = chain else {
            return None;
        };

        Some(Self {
            chain,
            last_persistent_txn,
            last_volatile_txn,
            last_persistent_slot,
        })
    }
}
