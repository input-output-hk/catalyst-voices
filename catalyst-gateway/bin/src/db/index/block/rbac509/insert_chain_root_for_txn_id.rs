//! Index RBAC Chain Root For Transaction ID Insert Query.
use std::{fmt::Debug, sync::Arc};

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::cassandra_db::EnvVars,
};

/// Index RBAC Chain Root by TX ID.
const INSERT_CHAIN_ROOT_FOR_TXN_ID_QUERY: &str =
    include_str!("./cql/insert_chain_root_for_txn_id.cql");

/// Insert Chain Root For Transaction ID Query Parameters
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Transaction ID Hash. 32 bytes.
    transaction_id: Vec<u8>,
    /// Chain Root Hash. 32 bytes.
    chain_root: Vec<u8>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("transaction_id", &self.transaction_id)
            .field("chain_root", &self.chain_root)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(chain_root: &[u8], transaction_id: &[u8]) -> Self {
        Params {
            transaction_id: transaction_id.to_vec(),
            chain_root: chain_root.to_vec(),
        }
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CHAIN_ROOT_FOR_TXN_ID_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = insert_queries {
            error!(error=%error,"Failed to prepare Insert Chain Root For TXN ID Query.");
        };

        insert_queries
    }
}
