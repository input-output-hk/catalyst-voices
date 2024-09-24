//! Insert RBAC 509 Indexed D
//!
//! Note, there are multiple ways TXO Data is indexed and they all happen in here.

use std::sync::Arc;

use scylla::{SerializeRow, Session};

use crate::{db::index::queries::SizedBatch, settings::CassandraEnvVars};

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
    pub(super) fn new(//
                      //stake_address: &[u8], slot_no: u64, txn: i16, txo: i16, address: &str, value: u64,
                      // txn_hash: &[u8],
    ) -> Self {
        todo!();
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
    pub(super) async fn prepare_batch(
        _session: &Arc<Session>, _cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        todo!();
    }
}
