//! Index Role-Based Access Control (RBAC) Registration.

pub(crate) mod insert_catalyst_id_for_stake_address;
pub(crate) mod insert_catalyst_id_for_txn_id;
pub(crate) mod insert_rbac509;
pub(crate) mod insert_rbac509_invalid;

use std::sync::Arc;

use cardano_blockchain_types::{Cip0134Uri, MultiEraBlock, Slot, TransactionHash, TxnIndex};
use catalyst_types::id_uri::IdUri;
use pallas::ledger::addresses::{Address, StakeAddress};
use rbac_registration::cardano::cip509::{Cip509, Cip509RbacMetadata};
use scylla::Session;
use tracing::error;

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    settings::cassandra_db::EnvVars,
};

/// Index RBAC 509 Registration Query Parameters
pub(crate) struct Rbac509InsertQuery {
    /// RBAC Registration Data captured during indexing.
    registrations: Vec<insert_rbac509::Params>,
    /// An invalid RBAC registration data.
    invalid: Vec<insert_rbac509_invalid::Params>,
    /// A Catalyst ID for transaction ID Data captured during indexing.
    catalyst_id_for_txn_id: Vec<insert_catalyst_id_for_txn_id::Params>,
    /// A Catalyst ID for stake address data captured during indexing.
    catalyst_id_for_stake_address: Vec<insert_catalyst_id_for_stake_address::Params>,
}

impl Rbac509InsertQuery {
    /// Creates new data set for RBAC 509 Registrations Insert Query Batch.
    pub(crate) fn new() -> Self {
        Rbac509InsertQuery {
            registrations: Vec::new(),
            invalid: Vec::new(),
            catalyst_id_for_txn_id: Vec::new(),
            catalyst_id_for_stake_address: Vec::new(),
        }
    }

    /// Prepare Batch of Insert RBAC 509 Registration Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<(SizedBatch, SizedBatch, SizedBatch, SizedBatch)> {
        Ok((
            insert_rbac509::Params::prepare_batch(session, cfg).await?,
            insert_rbac509_invalid::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_txn_id::Params::prepare_batch(session, cfg).await?,
            insert_catalyst_id_for_stake_address::Params::prepare_batch(session, cfg).await?,
        ))
    }

    /// Index the RBAC 509 registrations in a transaction.
    pub(crate) async fn index(
        &mut self, session: &Arc<CassandraSession>, txn_hash: TransactionHash, index: TxnIndex,
        block: &MultiEraBlock,
    ) {
        let slot = block.slot();
        let cip509 = match Cip509::new(block, index, &[]) {
            Ok(Some(v)) => v,
            Ok(None) => {
                // Nothing to index.
                return;
            },
            Err(e) => {
                // This registration is either completely corrupted or someone else is using "our"
                // label (`MetadatumLabel::CIP509_RBAC`). We don't want to index it even as
                // incorrect.
                error!(
                    slot = ?slot,
                    index = ?index,
                    "Invalid RBAC Registration Metadata in transaction: {e:?}"
                );
                return;
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

        let Some(catalyst_id) = catalyst_id(session, &cip509, txn_hash, slot, index).await else {
            error!("Unable to determine Catalyst id for registration: slot = {slot:?}, index = {index:?}, txn_hash = {txn_hash:?}");
            return;
        };

        let previous_transaction = cip509.previous_transaction();
        let purpose = cip509.purpose();
        match cip509.consume() {
            Ok((purpose, metadata, _)) => {
                self.registrations.push(insert_rbac509::Params::new(
                    catalyst_id.clone(),
                    txn_hash,
                    slot,
                    index,
                    purpose,
                    previous_transaction,
                ));
                self.catalyst_id_for_txn_id
                    .push(insert_catalyst_id_for_txn_id::Params::new(
                        catalyst_id.clone(),
                        txn_hash,
                        slot,
                        index,
                    ));
                for address in stake_addresses(&metadata) {
                    self.catalyst_id_for_stake_address.push(
                        insert_catalyst_id_for_stake_address::Params::new(
                            address,
                            slot,
                            index,
                            catalyst_id.clone(),
                        ),
                    );
                }
            },
            Err(report) => {
                self.invalid.push(insert_rbac509_invalid::Params::new(
                    catalyst_id,
                    txn_hash,
                    slot,
                    index,
                    purpose,
                    previous_transaction,
                    &report,
                ));
            },
        }
    }

    /// Execute the RBAC 509 Registration Indexing Queries.
    ///
    /// Consumes the `self` and returns a vector of futures.
    pub(crate) fn execute(self, session: &Arc<CassandraSession>) -> FallibleQueryTasks {
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

        query_handles
    }
}

/// Returns a Catalyst ID of the given registration.
async fn catalyst_id(
    session: &Arc<CassandraSession>, cip509: &Cip509, txn_hash: TransactionHash, slot: Slot,
    index: TxnIndex,
) -> Option<IdUri> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_transaction_id::{
        cache_for_transaction_id, Query,
    };

    let id = match cip509.previous_transaction() {
        Some(previous) => {
            Query::get_latest(session, previous.into())
                .await
                .inspect_err(|e| error!("{e:?}"))
                .ok()
                .flatten()?
                .catalyst_id
                .into()
        },
        None => cip509.catalyst_id()?.as_short_id(),
    };

    cache_for_transaction_id(txn_hash, id.clone(), slot, index);

    Some(id)
}

/// Returns stake addresses of the role 0.
fn stake_addresses(metadata: &Cip509RbacMetadata) -> Vec<StakeAddress> {
    let mut result = Vec::new();

    if let Some(uris) = metadata.certificate_uris.x_uris().get(&0) {
        result.extend(convert_stake_addresses(uris));
    }
    if let Some(uris) = metadata.certificate_uris.c_uris().get(&0) {
        result.extend(convert_stake_addresses(uris));
    }

    result
}

/// Converts a list of `Cip0134Uri` to a list of stake addresses.
fn convert_stake_addresses(uris: &[Cip0134Uri]) -> Vec<StakeAddress> {
    uris.iter()
        .filter_map(|uri| {
            match uri.address() {
                Address::Stake(a) => Some(a.clone()),
                _ => None,
            }
        })
        .collect()
}
