//! A RBAC context used during indexing.

use std::collections::{HashMap, HashSet};

use anyhow::Context;
use cardano_chain_follower::{hashes::TransactionId, Slot, StakeAddress, TxnIndex};
use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;
use futures::StreamExt;
use rbac_registration::providers::RbacRegistrationProvider;

use crate::{
    db::index::{
        queries::rbac::get_rbac_registrations::Query as RbacQuery, session::CassandraSession,
    },
    rbac::{
        chains_cache::cached_persistent_rbac_chain,
        get_chain::{apply_regs, build_rbac_chain, persistent_rbac_chain},
        latest_rbac_chain,
    },
};

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
        removed_stake_addresses: HashSet<StakeAddress>,
    ) {
        use std::collections::hash_map::Entry;

        let value = RbacQuery {
            txn_id: txn_id.into(),
            slot_no: slot.into(),
            txn_index: txn_index.into(),
            prv_txn_id: prv_txn.map(Into::into),
            removed_stake_addresses: removed_stake_addresses
                .into_iter()
                .map(Into::into)
                .collect(),
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

impl RbacRegistrationProvider for RbacBlockIndexingContext {
    async fn chain(
        &self,
        id: CatalystId,
        is_persistent: bool,
    ) -> anyhow::Result<Option<rbac_registration::registration::cardano::RegistrationChain>> {
        let chain = if is_persistent {
            persistent_rbac_chain(&id).await?
        } else {
            latest_rbac_chain(&id).await?.map(|i| i.chain)
        };

        // Apply additional registrations from context if any.
        if let Some(regs) = self.find_registrations(&id) {
            let regs = regs.iter().cloned();
            match chain {
                Some(c) => apply_regs(c, regs).await.map(Some),
                None => build_rbac_chain(regs).await,
            }
        } else {
            Ok(chain)
        }
    }

    async fn catalyst_id_from_txn_id(
        &self,
        txn_id: TransactionId,
        is_persistent: bool,
    ) -> anyhow::Result<Option<CatalystId>> {
        use crate::db::index::queries::rbac::get_catalyst_id_from_transaction_id::Query;

        // Check the context first.
        if let Some(catalyst_id) = self.find_transaction(&txn_id) {
            return Ok(Some(catalyst_id.to_owned()));
        }

        // Then try to find in the persistent database.
        let session =
            CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
        if let Some(id) = Query::get(&session, txn_id).await? {
            return Ok(Some(id));
        }

        // Conditionally check the volatile database.
        if !is_persistent {
            let session =
                CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
            return Query::get(&session, txn_id).await;
        }

        Ok(None)
    }

    async fn catalyst_id_from_stake_address(
        &self,
        address: &StakeAddress,
        is_persistent: bool,
    ) -> anyhow::Result<Option<CatalystId>> {
        use crate::db::index::queries::rbac::get_catalyst_id_from_stake_address::Query;

        // Check the context first.
        if let Some(catalyst_id) = self.find_address(address) {
            return Ok(Some(catalyst_id.to_owned()));
        }

        // Then try to find in the persistent database.
        let session =
            CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
        if let Some(id) = Query::latest(&session, address).await? {
            return Ok(Some(id));
        }

        // Conditionally check the volatile database.
        if !is_persistent {
            let session =
                CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
            return Query::latest(&session, address).await;
        }

        Ok(None)
    }

    async fn catalyst_id_from_public_key(
        &self,
        key: VerifyingKey,
        is_persistent: bool,
    ) -> anyhow::Result<Option<CatalystId>> {
        use crate::db::index::queries::rbac::get_catalyst_id_from_public_key::Query;

        // Check the context first.
        if let Some(catalyst_id) = self.find_public_key(&key) {
            return Ok(Some(catalyst_id.to_owned()));
        }

        // Then try to find in the persistent database.
        let session =
            CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
        if let Some(id) = Query::get(&session, key).await? {
            return Ok(Some(id));
        }

        // Conditionally check the volatile database.
        if !is_persistent {
            let session =
                CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
            return Query::get(&session, key).await;
        }

        Ok(None)
    }

    async fn is_chain_known(
        &self,
        id: CatalystId,
        is_persistent: bool,
    ) -> anyhow::Result<bool> {
        if self.find_registrations(&id).is_some() {
            return Ok(true);
        }

        let session =
            CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;

        // We only cache persistent chains, so it is ok to check the cache regardless of the
        // `is_persistent` parameter value.
        if cached_persistent_rbac_chain(&session, &id).is_some() {
            return Ok(true);
        }

        if is_cat_id_known(&session, &id).await? {
            return Ok(true);
        }

        // Conditionally check the volatile database.
        if !is_persistent {
            let session =
                CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
            if is_cat_id_known(&session, &id).await? {
                return Ok(true);
            }
        }

        Ok(false)
    }
}

/// Returns `true` if there is at least one registration with the given Catalyst ID.
async fn is_cat_id_known(
    session: &CassandraSession,
    id: &CatalystId,
) -> anyhow::Result<bool> {
    use crate::db::index::queries::rbac::get_rbac_registrations::{Query, QueryParams};

    Ok(Query::execute(session, QueryParams {
        catalyst_id: id.clone().into(),
    })
    .await?
    .next()
    .await
    .is_some())
}
