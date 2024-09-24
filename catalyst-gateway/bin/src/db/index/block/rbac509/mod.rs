//! Index Role-Based Access Control (RBAC) Registration.
#![allow(
    unused_imports,
    clippy::todo,
    dead_code,
    unused_variables,
    clippy::unused_async
)]

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
        todo!();
    }

    /// Index the RBAC 509 registrations in a transaction.
    pub(crate) fn index(
        &mut self, txn: usize, txn_index: i16, slot_no: u64, block: &MultiEraBlock,
    ) {
        todo!();
    }

    /// Execute the RBAC 509 Registration Indexing Queries.
    ///
    /// Consumes the `self` and returns a vector of futures.
    pub(crate) fn execute(self, session: &Arc<CassandraSession>) -> FallibleQueryTasks {
        let mut query_handles: FallibleQueryTasks = Vec::new();

        if !self.registrations.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                todo!();
            }));
        }

        query_handles
    }
}
