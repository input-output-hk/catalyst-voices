//! A RBAC context used during indexing.

use std::collections::{HashMap, HashSet};

use cardano_chain_follower::{Slot, StakeAddress, TxnIndex, hashes::TransactionId};
use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;

use crate::db::index::queries::rbac::get_rbac_registrations::Query as RbacQuery;

/// A RBAC context used during indexing.
///
/// During indexing the information is written to the database only after processing the
/// whole block. If there are multiple RBAC registrations in one block, then when
/// validating subsequent transactions we wouldn't be able to find information about the
/// previous ones in the database. This context is used to hold such information during
/// block processing in order to mitigate that issue.
pub struct RbacBlockIndexingContext {
    /// A map containing pending data that will be written in the `catalyst_id_for_txn_id`
    /// table.
    transactions: HashMap<TransactionId, CatalystId>,
    /// A map contains pending data that will be written in the
    /// `catalyst_id_for_stake_address` table.
    addresses: HashMap<StakeAddress, CatalystId>,
    /// A map containing pending data that will be written in the
    /// `catalyst_id_for_public_key` table.
    public_keys: HashMap<VerifyingKey, CatalystId>,
    /// A map containing pending data that will be written in the `rbac_registration`
    /// table.
    registrations: HashMap<CatalystId, Vec<RbacQuery>>,
}

impl RbacBlockIndexingContext {
    /// Creates a new context issue.
    pub fn new() -> Self {
        let transactions = HashMap::new();
        let addresses = HashMap::new();
        let public_keys = HashMap::new();
        let registrations = HashMap::new();

        Self {
            transactions,
            addresses,
            public_keys,
            registrations,
        }
    }

    /// Adds a transaction to the context.
    pub fn insert_transaction(
        &mut self,
        transaction: TransactionId,
        catalyst_id: CatalystId,
    ) {
        self.transactions.insert(transaction, catalyst_id);
    }

    /// Returns a Catalyst ID of the given transaction ID if it exists in the context.
    pub fn find_transaction(
        &self,
        transaction_id: &TransactionId,
    ) -> Option<&CatalystId> {
        self.transactions.get(transaction_id)
    }

    /// Adds a stake address to the context.
    pub fn insert_address(
        &mut self,
        address: StakeAddress,
        catalyst_id: CatalystId,
    ) {
        self.addresses.insert(address, catalyst_id);
    }

    /// Adds multiple addresses to the context.
    pub fn insert_addresses(
        &mut self,
        addresses: impl IntoIterator<Item = StakeAddress>,
        catalyst_id: &CatalystId,
    ) {
        for address in addresses {
            self.insert_address(address, catalyst_id.clone());
        }
    }

    /// Returns a Catalyst ID corresponding the given stake address.
    pub fn find_address(
        &self,
        address: &StakeAddress,
    ) -> Option<&CatalystId> {
        self.addresses.get(address)
    }

    /// Removes multiple addresses from the context.
    pub fn remove_addresses(
        &mut self,
        addresses: &HashSet<StakeAddress>,
    ) {
        for address in addresses {
            self.addresses.remove(address);
        }
    }

    /// Adds a public key to the context.
    pub fn insert_public_key(
        &mut self,
        key: VerifyingKey,
        catalyst_id: CatalystId,
    ) {
        self.public_keys.insert(key, catalyst_id);
    }

    /// Adds multiple public keys to the context.
    pub fn insert_public_keys(
        &mut self,
        keys: impl IntoIterator<Item = VerifyingKey>,
        catalyst_id: &CatalystId,
    ) {
        for key in keys {
            self.insert_public_key(key, catalyst_id.clone());
        }
    }

    /// Returns a Catalyst ID corresponding the given public key.
    pub fn find_public_key(
        &self,
        key: &VerifyingKey,
    ) -> Option<&CatalystId> {
        self.public_keys.get(key)
    }

    /// Adds a registration to the context.
    pub fn insert_registration(
        &mut self,
        id: CatalystId,
        txn_id: TransactionId,
        slot: Slot,
        txn_index: TxnIndex,
        prv_txn: Option<TransactionId>,
    ) {
        use std::collections::hash_map::Entry;

        let value = RbacQuery {
            txn_id: txn_id.into(),
            slot_no: slot.into(),
            txn_index: txn_index.into(),
            prv_txn_id: prv_txn.map(Into::into),
        };

        match self.registrations.entry(id) {
            Entry::Occupied(e) => {
                e.into_mut().push(value);
            },
            Entry::Vacant(e) => {
                e.insert(vec![value]);
            },
        }
    }

    /// Returns a list of registrations.
    pub fn find_registrations(
        &self,
        id: &CatalystId,
    ) -> Option<&[RbacQuery]> {
        self.registrations.get(id).map(Vec::as_slice)
    }
}
