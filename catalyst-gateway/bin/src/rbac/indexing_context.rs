//! A RBAC context used during indexing.

use std::collections::HashMap;

use cardano_blockchain_types::TransactionId;
use catalyst_types::catalyst_id::CatalystId;

/// A RBAC context used during indexing.
///
/// During indexing the information is written to the database only after processing the
/// whole block. If there are multiple RBAC registrations in one block, then when
/// validating subsequent transactions we wouldn't be able to find information about the
/// previous ones in the database. This context is used to hold such information during
/// block processing in order to mitigate that issue.
pub struct RbacIndexingContext {
    transactions: HashMap<TransactionId, CatalystId>,
}

impl RbacIndexingContext {
    /// Creates a new context issue.
    pub fn new() -> Self {
        let transactions = HashMap::new();

        Self { transactions }
    }

    /// Adds a transaction to the context.
    pub fn insert_transaction(&mut self, transaction: TransactionId, catalyst_id: CatalystId) {
        self.transactions.insert(transaction, catalyst_id);
    }

    /// Returns a Catalyst ID of the given transaction ID if it exists in the context.
    pub fn find_transaction(&self, transaction_id: &TransactionId) -> Option<&CatalystId> {
        self.transactions.get(transaction_id)
    }
}
