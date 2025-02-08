//! Index Role-Based Access Control (RBAC) Registration.

pub(crate) mod insert_catalyst_id_for_stake_address;
pub(crate) mod insert_catalyst_id_for_txn_id;
pub(crate) mod insert_rbac509;
pub(crate) mod insert_rbac509_invalid;

use std::sync::{Arc, LazyLock};

use cardano_blockchain_types::{Cip0134Uri, MultiEraBlock, Slot, TransactionHash, TxnIndex};
use catalyst_types::id_uri::IdUri;
use moka::{policy::EvictionPolicy, sync::Cache};
use pallas::ledger::addresses::Address;
use rbac_registration::cardano::cip509::{Cip509, Cip509RbacMetadata};
use scylla::Session;
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
            session::CassandraSession,
        },
        types::DbCip19StakeAddress,
    },
    settings::cassandra_db::EnvVars,
};

/// A Catalyst ID by transaction ID cache.
static CATALYST_ID_BY_TXN_ID_CACHE: LazyLock<Cache<TransactionHash, IdUri>> = LazyLock::new(|| {
    Cache::builder()
        // Set Eviction Policy to `LRU`
        .eviction_policy(EvictionPolicy::lru())
        // Create the cache.
        .build()
});

/// Index RBAC 509 Registration Query Parameters
pub(crate) struct Rbac509InsertQuery {
    /// RBAC Registration Data captured during indexing.
    registrations: Vec<insert_rbac509::Params>,
    /// Invalid RBAC Registration Data.
    invalid: Vec<insert_rbac509_invalid::Params>,
    /// Chain Root For Transaction ID Data captured during indexing.
    catalyst_id_for_txn_id: Vec<insert_catalyst_id_for_txn_id::Params>,
    /// Chain Root For Stake Address Data captured during indexing.
    catalyst_id_for_stake_address: Vec<insert_catalyst_id_for_stake_address::Params>,
}

impl Rbac509InsertQuery {
    /// Create new data set for RBAC 509 Registrations Insert Query Batch.
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
                    catalyst_id.clone().into(),
                    txn_hash.into(),
                    slot.into(),
                    index.into(),
                    purpose.into(),
                    previous_transaction.map(Into::into),
                ));
                self.catalyst_id_for_txn_id
                    .push(insert_catalyst_id_for_txn_id::Params::new(
                        catalyst_id.clone().into(),
                        txn_hash.into(),
                        slot.into(),
                        index.into(),
                    ));
                for address in stake_addresses(&metadata) {
                    self.catalyst_id_for_stake_address.push(
                        insert_catalyst_id_for_stake_address::Params::new(
                            address,
                            slot.into(),
                            index.into(),
                            catalyst_id.clone().into(),
                        ),
                    );
                }
            },
            Err(report) => {
                self.invalid.push(insert_rbac509_invalid::Params::new(
                    catalyst_id.into(),
                    txn_hash.into(),
                    slot.into(),
                    index.into(),
                    purpose.map(Into::into),
                    previous_transaction.map(Into::into),
                    report,
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
                        PreparedQuery::RbacCatalystIdForTxnIdInsertQuery,
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
                        PreparedQuery::RbacCatalystIdForStakeAddressInsertQuery,
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

    cache_for_transaction_id(
        txn_hash.into(),
        id.clone().into(),
        slot.into(),
        index.into(),
    );
    CATALYST_ID_BY_TXN_ID_CACHE.insert(txn_hash, id.clone());
    Some(id)
}

/// Returns stake addresses of the role 0.
fn stake_addresses(metadata: &Cip509RbacMetadata) -> Vec<DbCip19StakeAddress> {
    let mut result = Vec::new();

    if let Some(uris) = metadata.certificate_uris.x_uris().get(&0) {
        result.extend(convert_stake_addresses(uris));
    }
    if let Some(uris) = metadata.certificate_uris.c_uris().get(&0) {
        result.extend(convert_stake_addresses(uris));
    }

    result
}

/// Converts a list of `Cip0134Uri` to a list of `DbCip19StakeAddress`.
fn convert_stake_addresses(uris: &[Cip0134Uri]) -> Vec<DbCip19StakeAddress> {
    uris.into_iter()
        .filter_map(|uri| {
            match uri.address() {
                Address::Stake(a) => Some(a.clone().into()),
                _ => None,
            }
        })
        .collect()
}
