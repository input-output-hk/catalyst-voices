//! Insert RBAC 509 Indexed D
//!
//! Note, there are multiple ways TXO Data is indexed and they all happen in here.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::CassandraEnvVars,
};

/// RBAC Registration Indexing query
#[allow(dead_code)]
const INSERT_RBAC509_QUERY: &str = include_str!("./cql/insert_rbac509.cql");

/// Insert RBAC Registration Query Parameters
#[derive(SerializeRow, Debug)]
pub(super) struct Params {
    /// Chain Root Hash. 32 bytes.
    chain_root: Vec<u8>,
    /// Transaction ID Hash. 32 bytes.
    transaction_id: Vec<u8>,
    /// Purpose.`UUIDv4`. 16 bytes.
    purpose: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Hash of Previous Transaction. Is `None` for the first registration. 32 Bytes.
    prv_txn_id: Option<Vec<u8>>,
}

#[allow(clippy::todo, dead_code, clippy::unused_async)]
impl Params {
    /// Create a new record for this transaction.
    pub(super) fn new(
        chain_root: Vec<u8>, transaction_id: Vec<u8>, purpose: Vec<u8>, slot_no: u64, txn: i16,
        prv_txn_id: Option<Vec<u8>>,
    ) -> Self {
        Params {
            chain_root,
            transaction_id,
            purpose,
            slot_no: num_bigint::BigInt::from(slot_no),
            txn,
            prv_txn_id,
        }
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_RBAC509_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = insert_queries {
            error!(error=%error,"Failed to prepare Insert RBAC 509 Registration Query.");
        };

        insert_queries
    }
}
