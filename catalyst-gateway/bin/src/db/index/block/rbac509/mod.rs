//! Index Role-Based Access Control (RBAC) Registration.

pub(crate) mod insert_catalyst_id_for_public_key;
pub(crate) mod insert_catalyst_id_for_stake_address;
pub(crate) mod insert_catalyst_id_for_txn_id;
pub(crate) mod insert_rbac509;
pub(crate) mod insert_rbac509_invalid;

use std::{
    collections::{BTreeSet, HashSet},
    sync::Arc,
};

use anyhow::{Context, Result};
use cardano_chain_follower::{MultiEraBlock, Slot, TxnIndex, hashes::TransactionId};
use rbac_registration::cardano::cip509::Cip509;
use scylla::client::session::Session;
use tokio::sync::watch;
use tracing::{debug, error};

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    metrics::caches::rbac::{inc_index_sync, inc_invalid_rbac_reg_count},
    rbac::{
        RbacBlockIndexingContext, RbacValidationError, RbacValidationSuccess,
        validate_rbac_registration,
    },
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
    ) -> Result<(SizedBatch, SizedBatch, SizedBatch, SizedBatch, SizedBatch)> {
        Ok((
            insert_rbac509::Params::prepare_batch(session, cfg).await?,
            insert_rbac509_invalid::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_txn_id::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_stake_address::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_public_key::Params::prepare_batch(session, cfg).await?,
        ))
    }

    /// Index the RBAC 509 registrations in a transaction.
    #[allow(clippy::too_many_lines)]
    pub(crate) async fn index(
        &mut self,
        txn_hash: TransactionId,
        index: TxnIndex,
        block: &MultiEraBlock,
        pending_blocks: &mut watch::Receiver<BTreeSet<Slot>>,
        our_end: Slot,
        context: &mut RbacBlockIndexingContext,
    ) -> Result<()> {
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

        let previous_transaction = cip509.previous_transaction();
        // `Box::pin` is used here because of the future size (`clippy::large_futures` lint).
        match Box::pin(validate_rbac_registration(
            cip509,
            block.is_immutable(),
            context,
        ))
        .await
        {
            // Write updates to the database. There can be multiple updates in one registration
            // because a new chain can take ownership of stake addresses of the existing chains and
            // in that case we want to record changes to all those chains as well as the new one.
            Ok(RbacValidationSuccess {
                catalyst_id,
                stake_addresses,
                public_keys,
                modified_chains,
                purpose,
            }) => {
                // Record the transaction identifier (hash) of a new registration.
                self.catalyst_id_for_txn_id
                    .push(insert_catalyst_id_for_txn_id::Params::new(
                        catalyst_id.clone(),
                        txn_hash,
                        slot,
                    ));
                // Record new stake addresses.
                for address in stake_addresses {
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
                    self.catalyst_id_for_public_key.push(
                        insert_catalyst_id_for_public_key::Params::new(
                            key,
                            slot,
                            catalyst_id.clone(),
                        ),
                    );
                }
                // Update the chain this registration belongs to.
                self.registrations.push(insert_rbac509::Params::new(
                    catalyst_id,
                    txn_hash,
                    slot,
                    index,
                    previous_transaction,
                    // Addresses can only be removed from other chains, so this list is always
                    // empty for the chain that is being updated.
                    HashSet::new(),
                    purpose,
                ));

                // Update other chains that were affected by this registration.
                for (catalyst_id, removed_addresses) in modified_chains {
                    self.registrations.push(insert_rbac509::Params::new(
                        catalyst_id.clone(),
                        txn_hash,
                        slot,
                        index,
                        // In this case the addresses were removed by another chain, so it doesn't
                        // make sense to include a previous transaction ID unrelated to the chain
                        // that is being updated.
                        None,
                        removed_addresses,
                        None,
                    ));
                }
            },
            // Invalid registrations are being recorded in order to report failure.
            Err(RbacValidationError::InvalidRegistration {
                catalyst_id,
                purpose,
                report,
            }) => {
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
            },
            // This isn't a hard error because user input can contain invalid information. If there
            // is no Catalyst ID, then we cannot record this registration as invalid and can only
            // ignore (and log) it.
            Err(RbacValidationError::UnknownCatalystId) => {
                debug!(
                    slot = ?slot,
                    index = ?index,
                    txn_hash = ?txn_hash,
                    "Unable to determine Catalyst id for registration"
                );
            },
            Err(RbacValidationError::Fatal(e)) => {
                error!(
                   slot = ?slot,
                   index = ?index,
                   txn_hash = ?txn_hash,
                   err = ?e,
                   "Error indexing RBAC registration"
                );
                // Propagate an error.
                return Err(e);
            },
        }

        Ok(())
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
                inner_session
                    .execute_batch(PreparedQuery::Rbac509InsertQuery, self.registrations)
                    .await
            }));
        }

        if !self.invalid.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(PreparedQuery::Rbac509InvalidInsertQuery, self.invalid)
                    .await
            }));
        }

        if !self.catalyst_id_for_txn_id.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::CatalystIdForTxnIdInsertQuery,
                        self.catalyst_id_for_txn_id,
                    )
                    .await
            }));
        }

        if !self.catalyst_id_for_stake_address.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::CatalystIdForStakeAddressInsertQuery,
                        self.catalyst_id_for_stake_address,
                    )
                    .await
            }));
        }

        if !self.catalyst_id_for_public_key.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::CatalystIdForPublicKeyInsertQuery,
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
) -> Result<()> {
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
