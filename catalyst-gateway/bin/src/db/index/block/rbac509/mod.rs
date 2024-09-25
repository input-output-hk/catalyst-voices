//! Index Role-Based Access Control (RBAC) Registration.

mod insert_rbac509;

use std::sync::Arc;

use cardano_chain_follower::{Metadata, MultiEraBlock};
use scylla::Session;

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    settings::CassandraEnvVars,
};

/// Index RBAC 509 Registration Query Parameters
pub(crate) struct Rbac509InsertQuery {
    /// RBAC Registration Data captured during indexing.
    registrations: Vec<insert_rbac509::Params>,
}

impl Rbac509InsertQuery {
    /// Create new data set for RBAC 509 Registrations Insert Query Batch.
    pub(crate) fn new() -> Self {
        Rbac509InsertQuery {
            registrations: Vec::new(),
        }
    }

    /// Prepare Batch of Insert RBAC 509 Registration Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        insert_rbac509::Params::prepare_batch(session, cfg).await
    }

    /// Index the RBAC 509 registrations in a transaction.
    #[allow(clippy::todo, unused_variables)]
    pub(crate) fn index(
        &mut self, txn_hash: &[u8], txn: usize, txn_index: i16, slot_no: u64, block: &MultiEraBlock,
    ) {
        if let Some(decoded_metadata) = block.txn_metadata(txn, Metadata::cip509::LABEL) {
            #[allow(irrefutable_let_patterns)]
            if let Metadata::DecodedMetadataValues::Cip509(rbac) = &decoded_metadata.value {
                if let Some(tx_id) = rbac.prv_tx_id {
                    // WIP: fetch chain_root from cache or DB
                } else {
                    let chain_root = txn_hash.to_vec();
                    self.registrations.push(insert_rbac509::Params::new(
                        chain_root,
                        txn_hash.to_vec(),
                        slot_no,
                        txn_index,
                        rbac,
                    ));
                }
            }
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

        query_handles
    }
}
