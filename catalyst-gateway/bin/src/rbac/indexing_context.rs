//! A RBAC context used during indexing.

use std::collections::HashMap;

use cardano_blockchain_types::{StakeAddress, TransactionId};
use catalyst_types::catalyst_id::CatalystId;

/// A RBAC context used during indexing.
///
/// During indexing the information is written to the database only after processing the
/// whole block. If there are multiple RBAC registrations in one block, then when
/// validating subsequent transactions we wouldn't be able to find information about the
/// previous ones in the database. This context is used to hold such information during
/// block processing in order to mitigate that issue.
pub struct RbacIndexingContext {
    /// A map containing pending data that will be written in the `catalyst_id_for_txn_id`
    /// table.
    transactions: HashMap<TransactionId, CatalystId>,
    /// A map contains pending data that will be written in the
    /// `catalyst_id_for_stake_address` table.
    addresses: HashMap<StakeAddress, CatalystId>,
}

impl RbacIndexingContext {
    /// Creates a new context issue.
    pub fn new() -> Self {
        let transactions = HashMap::new();
        let addresses = HashMap::new();

        Self {
            transactions,
            addresses,
        }
    }

    /// Adds a transaction to the context.
    pub fn insert_transaction(&mut self, transaction: TransactionId, catalyst_id: CatalystId) {
        self.transactions.insert(transaction, catalyst_id);
    }

    /// Returns a Catalyst ID of the given transaction ID if it exists in the context.
    pub fn find_transaction(&self, transaction_id: &TransactionId) -> Option<&CatalystId> {
        self.transactions.get(transaction_id)
    }

    /// Adds a stake address to the context.
    pub fn insert_address(&mut self, address: StakeAddress, catalyst_id: CatalystId) {
        self.addresses.insert(address, catalyst_id);
    }

    /// Returns a Catalyst ID corresponding the the given stake address.
    pub fn find_address(&self, address: &StakeAddress) -> Option<&CatalystId> {
        self.addresses.get(address)
    }
}
