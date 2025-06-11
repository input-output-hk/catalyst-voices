//! Index Role-Based Access Control (RBAC) Registration.

pub(crate) mod insert_catalyst_id_for_public_key;
pub(crate) mod insert_catalyst_id_for_stake_address;
pub(crate) mod insert_catalyst_id_for_txn_id;
pub(crate) mod insert_rbac509;
pub(crate) mod insert_rbac509_invalid;

use std::sync::Arc;

use cardano_blockchain_types::{MultiEraBlock, TransactionId, TxnIndex};
use rbac_registration::cardano::cip509::Cip509;
use scylla::Session;
use tracing::{debug, error};

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    rbac_cache::{RbacCacheAddError, RbacCacheAddSuccess, RBAC_CACHE},
    settings::cassandra_db::EnvVars,
};

/// Index RBAC 509 Registration Query Parameters
#[allow(dead_code)]
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
        session: &Arc<Session>, cfg: &EnvVars,
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
    pub(crate) fn index(
        &mut self, txn_hash: TransactionId, index: TxnIndex, block: &MultiEraBlock,
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
                debug!(
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

        let previous_transaction = cip509.previous_transaction();
        match RBAC_CACHE.add(cip509, block.is_immutable()) {
            Ok(RbacCacheAddSuccess { catalyst_id }) => {
                self.registrations.push(insert_rbac509::Params::new(
                    catalyst_id.clone(),
                    txn_hash,
                    slot,
                    index,
                    previous_transaction,
                    // TODO: FIXME: This should be fixed along with updating indexing logic.
                    std::collections::HashSet::new(),
                ));
            },
            Err(RbacCacheAddError::InvalidRegistration {
                catalyst_id,
                purpose,
                report,
            }) => {
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
            Err(RbacCacheAddError::UnknownCatalystId) => {
                debug!("Unable to determine Catalyst id for registration: slot = {slot:?}, index = {index:?}, txn_hash = {txn_hash:?}");
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

        query_handles
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::db::index::tests::test_utils;

    #[tokio::test]
    async fn index() {
        let block = test_utils::block_3();
        let mut query = Rbac509InsertQuery::new();
        let txn_hash = "1bf8eb4da8fe5910cc890025deb9740ba5fa4fd2ac418ccbebfd6a09ed10e88b"
            .parse()
            .unwrap();
        query.index(txn_hash, 0.into(), &block);
        assert!(query.invalid.is_empty());
        assert_eq!(1, query.registrations.len());
    }

    // The invalid vec is empty in this test because `RBAC_CACHE.add()` returns
    // `UnknownCatalystId` for that registration.
    #[tokio::test]
    async fn index_invalid() {
        let block = test_utils::block_4();
        let mut query = Rbac509InsertQuery::new();
        let txn_hash = "337d35026efaa48b5ee092d38419e102add1b535364799eb8adec8ac6d573b79"
            .parse()
            .unwrap();
        query.index(txn_hash, 0.into(), &block);
        assert!(query.registrations.is_empty());
        assert!(query.invalid.is_empty());
    }
}
