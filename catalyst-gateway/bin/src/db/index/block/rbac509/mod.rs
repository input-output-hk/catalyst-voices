//! Index Role-Based Access Control (RBAC) Registration.

pub(crate) mod insert_catalyst_id_for_public_key;
pub(crate) mod insert_catalyst_id_for_stake_address;
pub(crate) mod insert_catalyst_id_for_txn_id;
pub(crate) mod insert_rbac509;
pub(crate) mod insert_rbac509_invalid;

use std::{
    collections::{BTreeSet, HashMap, HashSet},
    sync::Arc,
};

use anyhow::Context;
use cardano_chain_follower::{MultiEraBlock, Slot, StakeAddress, TxnIndex, hashes::TransactionId};
use catalyst_types::{catalyst_id::CatalystId, problem_report::ProblemReport, uuid::UuidV4};
use ed25519_dalek::VerifyingKey;
use futures::{StreamExt, TryStreamExt};
use rbac_registration::{
    cardano::{cip509::Cip509, provider::RbacChainsProvider as _},
    registration::cardano::RegistrationChain,
};
use scylla::client::session::Session;
use tokio::sync::watch;
use tracing::{debug, error};

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, SizedBatch},
        session::CassandraSession,
    },
    metrics::caches::rbac::{inc_index_sync, inc_invalid_rbac_reg_count},
    rbac::{RbacBlockIndexingContext, cache_persistent_rbac_chain, provider::RbacChainsProvider},
    settings::cassandra_db::EnvVars,
};

/// Index RBAC 509 Registration Query Parameters
#[derive(Debug)]
pub(crate) struct Rbac509InsertQuery {
    /// RBAC Registration Data captured during indexing.
    pub(crate) registrations: Vec<insert_rbac509::Params>,
    /// An invalid RBAC registration data.
    pub(crate) invalid: Vec<insert_rbac509_invalid::Params>,
    /// A Catalyst ID for transaction ID Data captured during indexing.
    catalyst_id_for_txn_id: Vec<insert_catalyst_id_for_txn_id::Params>,
    /// A Catalyst ID for stake address data captured during indexing.
    catalyst_id_for_stake_address: Vec<insert_catalyst_id_for_stake_address::Params>,
    /// A Catalyst ID for public key data captured during indexing.
    catalyst_id_for_public_key: Vec<insert_catalyst_id_for_public_key::Params>,
}

impl Rbac509InsertQuery {
    /// Creates new data set for RBAC 509 Registrations Insert Query Batch.
    pub(crate) fn new() -> Self {
        Rbac509InsertQuery {
            registrations: Vec::new(),
            invalid: Vec::new(),
            catalyst_id_for_txn_id: Vec::new(),
            catalyst_id_for_stake_address: Vec::new(),
            catalyst_id_for_public_key: Vec::new(),
        }
    }

    /// Prepare Batch of Insert RBAC 509 Registration Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>,
        cfg: &EnvVars,
    ) -> anyhow::Result<(SizedBatch, SizedBatch, SizedBatch, SizedBatch, SizedBatch)> {
        Ok((
            insert_rbac509::Params::prepare_batch(session, cfg).await?,
            insert_rbac509_invalid::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_txn_id::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_stake_address::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_public_key::Params::prepare_batch(session, cfg).await?,
        ))
    }

    /// Index the RBAC 509 registrations in a transaction.
    pub(crate) async fn index(
        &mut self,
        txn_hash: TransactionId,
        index: TxnIndex,
        block: &MultiEraBlock,
        pending_blocks: &mut watch::Receiver<BTreeSet<Slot>>,
        our_end: Slot,
        context: &mut RbacBlockIndexingContext,
    ) -> anyhow::Result<()> {
        let slot = block.slot();
        let cip509 = match Cip509::new(block, index, &[]) {
            Ok(Some(v)) => v,
            Ok(None) => {
                // Nothing to index.
                return Ok(());
            },
            Err(e) => {
                // This registration is either completely corrupted or someone else is using "our"
                // label (`MetadatumLabel::CIP509_RBAC`). We don't want to index it even as
                // incorrect.
                debug!(
                    slot = ?slot,
                    index = ?index,
                    err = ?e,
                    "Invalid RBAC Registration Metadata in transaction"
                );
                return Ok(());
            },
        };

        // This should never happen, but let's check anyway.
        if slot != cip509.origin().point().slot_or_default() {
            error!(
                "Cip509 slot mismatch: expected {slot:?}, got {:?}",
                cip509.origin().point().slot_or_default()
            );
        }
        if txn_hash != cip509.txn_hash() {
            error!(
                "Cip509 txn hash mismatch: expected {txn_hash}, got {}",
                cip509.txn_hash()
            );
        }

        // To properly validate a new registration we need to index all the previous blocks, so
        // here we are going to wait till the other tasks have indexed the blocks before this one.
        wait_for_previous_blocks(pending_blocks, our_end, block.slot()).await?;

        if let Some(previous_txn) = cip509.previous_transaction() {
            self.try_record_chain_update(&cip509, previous_txn, block.is_immutable(), context)
                .await?;
        } else {
            self.try_record_new_chain(&cip509, block.is_immutable(), context)
                .await?;
        }

        Ok(())
    }

    /// Validating the provided registration as an update for an existing chain, preparing
    /// corresponding updates
    async fn try_record_chain_update(
        &mut self,
        reg: &Cip509,
        previous_txn: TransactionId,
        is_persistent: bool,
        context: &mut RbacBlockIndexingContext,
    ) -> anyhow::Result<()> {
        // Find a chain this registration belongs to.
        let state = RbacChainsProvider::new(is_persistent, context);

        let slot = reg.origin().point().slot_or_default();
        let txn_index = reg.origin().txn_index();
        let txn_hash = reg.txn_hash();

        let Some(catalyst_id) = state.catalyst_id_from_txn_id(previous_txn).await? else {
            // This isn't a hard error because user input can contain invalid information.
            // If there is no Catalyst ID, then we cannot record this
            // registration as invalid and can only ignore (and log) it.
            debug!(
                slot = ?slot,
                txn_index = ?txn_index,
                txn_hash = ?txn_hash,
                "Unable to determine Catalyst id for registration"
            );
            return Ok(());
        };

        let chain = state.chain(&catalyst_id).await?.context(format!(
                "{catalyst_id} is present in 'catalyst_id_for_txn_id' table, but not in 'rbac_registration'"
        ))?;

        // Try to add a new registration to the chain.
        let Some(new_chain) = chain.update(reg, &state).await? else {
            self.record_invalid_registration(
                txn_hash,
                txn_index,
                slot,
                chain.catalyst_id().clone(),
                Some(previous_txn),
                reg.purpose(),
                reg.report().clone(),
            );

            return Ok(());
        };

        let previous_addresses = chain.stake_addresses();
        let new_addresses = new_chain.stake_addresses();
        let added_addresses: HashSet<_> = new_addresses
            .difference(&previous_addresses)
            .cloned()
            .collect();
        let removed_addresses: HashSet<_> = previous_addresses
            .difference(&new_addresses)
            .cloned()
            .collect();
        let public_keys = reg
            .all_roles()
            .iter()
            .filter_map(|v| reg.signing_public_key_for_role(*v))
            .collect::<HashSet<_>>();
        // During the chain update, it cannot be an any stake addresses updates
        let modified_chains = HashMap::new();
        let purpose = reg.purpose();

        if is_persistent {
            cache_persistent_rbac_chain(catalyst_id.clone(), new_chain);
        }

        self.record_valid_registration(
            txn_hash,
            txn_index,
            slot,
            catalyst_id.clone(),
            Some(previous_txn),
            &added_addresses,
            &removed_addresses,
            public_keys,
            modified_chains,
            purpose,
            context,
        );

        Ok(())
    }

    /// Validating the provided registration as a beginning of a new chain, preparing
    /// corresponding updates
    async fn try_record_new_chain(
        &mut self,
        reg: &Cip509,
        is_persistent: bool,
        context: &mut RbacBlockIndexingContext,
    ) -> anyhow::Result<()> {
        /// Size of the buffered list adaptor of futures.
        const FUTURES_BUFFER_SIZE: usize = 10;

        let provider = RbacChainsProvider::new(is_persistent, context);

        let slot = reg.origin().point().slot_or_default();
        let txn_index = reg.origin().txn_index();
        let txn_hash = reg.txn_hash();

        // Try to start a new chain.
        let Some(new_chain) = RegistrationChain::new(reg, &provider).await? else {
            if let Some(cat_id) = reg.catalyst_id() {
                self.record_invalid_registration(
                    txn_hash,
                    txn_index,
                    slot,
                    cat_id.clone(),
                    None,
                    reg.purpose(),
                    reg.report().clone(),
                );
            } else {
                // This isn't a hard error because user input can contain invalid information.
                // If there is no Catalyst ID, then we cannot record this
                // registration as invalid and can only ignore (and log) it.
                debug!(
                    slot = ?slot,
                    txn_index = ?txn_index,
                    txn_hash = ?txn_hash,
                    "Unable to determine Catalyst id for registration"
                );
            }

            return Ok(());
        };

        let catalyst_id = new_chain.catalyst_id();
        let stake_addresses = new_chain.stake_addresses();
        let public_keys = reg
            .all_roles()
            .iter()
            .filter_map(|v| reg.signing_public_key_for_role(*v))
            .collect::<HashSet<_>>();
        let purpose = reg.purpose();

        let futures = reg.stake_addresses().clone().into_iter().map(|addr| {
            async {
                anyhow::Ok((
                    provider.chain_catalyst_id_from_stake_address(&addr).await?,
                    addr,
                ))
            }
        });
        let modified_chains = futures::stream::iter(futures)
            .buffer_unordered(FUTURES_BUFFER_SIZE)
            .try_fold(
                HashMap::<CatalystId, HashSet<StakeAddress>>::new(),
                |mut acc, (cat_id, addr)| {
                    async {
                        if let Some(cat_id) = cat_id {
                            acc.entry(cat_id).or_default().insert(addr);
                        }
                        anyhow::Ok(acc)
                    }
                },
            )
            .await?;

        self.record_valid_registration(
            txn_hash,
            txn_index,
            slot,
            catalyst_id.clone(),
            None,
            &stake_addresses,
            &HashSet::new(),
            public_keys,
            modified_chains,
            purpose,
            context,
        );

        Ok(())
    }

    /// Making corresponding records according to the valid registration
    #[allow(clippy::too_many_arguments)]
    fn record_valid_registration(
        &mut self,
        txn_hash: TransactionId,
        index: TxnIndex,
        slot: Slot,
        catalyst_id: CatalystId,
        previous_transaction: Option<TransactionId>,
        added_stake_addresses: &HashSet<StakeAddress>,
        removed_stake_addresses: &HashSet<StakeAddress>,
        public_keys: HashSet<VerifyingKey>,
        modified_chains: HashMap<CatalystId, HashSet<StakeAddress>>,
        purpose: Option<UuidV4>,
        context: &mut RbacBlockIndexingContext,
    ) {
        context.insert_transaction(txn_hash, catalyst_id.clone());
        context.insert_addresses(added_stake_addresses.clone(), &catalyst_id);
        context.remove_addresses(removed_stake_addresses.clone());
        context.insert_public_keys(public_keys.clone(), &catalyst_id);
        context.insert_registration(
            catalyst_id.clone(),
            txn_hash,
            slot,
            index,
            previous_transaction,
        );

        // Record the transaction identifier (hash) of a new registration.
        self.catalyst_id_for_txn_id
            .push(insert_catalyst_id_for_txn_id::Params::new(
                catalyst_id.clone(),
                txn_hash,
                slot,
            ));
        // Record new stake addresses that are not marked as removed.
        for address in added_stake_addresses
            .difference(removed_stake_addresses)
            .cloned()
        {
            self.catalyst_id_for_stake_address.push(
                insert_catalyst_id_for_stake_address::Params::new(
                    address,
                    slot,
                    index,
                    catalyst_id.clone(),
                ),
            );
        }
        // Record new public keys.
        for key in public_keys {
            self.catalyst_id_for_public_key
                .push(insert_catalyst_id_for_public_key::Params::new(
                    key,
                    slot,
                    catalyst_id.clone(),
                ));
        }
        // Update the chain this registration belongs to.
        self.registrations.push(insert_rbac509::Params::new(
            catalyst_id,
            txn_hash,
            slot,
            index,
            previous_transaction,
            purpose,
        ));

        // Update other chains that were affected by this registration.
        for (catalyst_id, _) in modified_chains {
            self.registrations.push(insert_rbac509::Params::new(
                catalyst_id.clone(),
                txn_hash,
                slot,
                index,
                // In this case the addresses were removed by another chain, so it doesn't
                // make sense to include a previous transaction ID unrelated to the chain
                // that is being updated.
                None,
                None,
            ));
        }
    }

    /// Making corresponding records according to the valid registration
    #[allow(clippy::too_many_arguments)]
    fn record_invalid_registration(
        &mut self,
        txn_hash: TransactionId,
        index: TxnIndex,
        slot: Slot,
        catalyst_id: CatalystId,
        previous_transaction: Option<TransactionId>,
        purpose: Option<UuidV4>,
        report: ProblemReport,
    ) {
        inc_invalid_rbac_reg_count();
        self.invalid.push(insert_rbac509_invalid::Params::new(
            catalyst_id,
            txn_hash,
            slot,
            index,
            purpose,
            previous_transaction,
            report,
        ));
    }

    /// Execute the RBAC 509 Registration Indexing Queries.
    ///
    /// Consumes the `self` and returns a vector of futures.
    pub(crate) fn execute(
        self,
        session: &Arc<CassandraSession>,
    ) -> FallibleQueryTasks {
        let mut query_handles: FallibleQueryTasks = Vec::new();

        if !self.registrations.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                insert_rbac509::Params::execute_batch(&inner_session, self.registrations).await
            }));
        }

        if !self.invalid.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                insert_rbac509_invalid::Params::execute_batch(&inner_session, self.invalid).await
            }));
        }

        if !self.catalyst_id_for_txn_id.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                insert_catalyst_id_for_txn_id::Params::execute_batch(
                    &inner_session,
                    self.catalyst_id_for_txn_id,
                )
                .await
            }));
        }

        if !self.catalyst_id_for_stake_address.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                insert_catalyst_id_for_stake_address::Params::execute_batch(
                    &inner_session,
                    self.catalyst_id_for_stake_address,
                )
                .await
            }));
        }

        if !self.catalyst_id_for_public_key.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                insert_catalyst_id_for_public_key::Params::execute_batch(
                    &inner_session,
                    self.catalyst_id_for_public_key,
                )
                .await
            }));
        }

        query_handles
    }
}

/// Waits till all previous blocks are indexed.
///
/// The given `our_end` is excluded from the list of unprocessed blocks.
async fn wait_for_previous_blocks(
    pending_blocks: &mut watch::Receiver<BTreeSet<Slot>>,
    our_end: Slot,
    current_slot: Slot,
) -> anyhow::Result<()> {
    loop {
        if pending_blocks
            .borrow_and_update()
            .iter()
            .filter(|&&v| v == our_end)
            .all(|&slot| slot > current_slot)
        {
            return Ok(());
        }

        inc_index_sync();

        pending_blocks
            .changed()
            .await
            .context("Unprocessed blocks channel was closed unexpectedly")?;
    }
}
