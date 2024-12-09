//! Insert RBAC 509 Registration Query.

use std::{fmt::Debug, sync::Arc};

use rbac_registration::cardano::cip509::Cip509;
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::cassandra_db::EnvVars,
};

/// RBAC Registration Indexing query
const INSERT_RBAC509_QUERY: &str = include_str!("./cql/insert_rbac509.cql");

/// Insert RBAC Registration Query Parameters
#[derive(SerializeRow)]
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
    prv_txn_id: MaybeUnset<Vec<u8>>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let prv_txn_id = match self.prv_txn_id {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(ref v) => &hex::encode(v),
        };
        f.debug_struct("Params")
            .field("chain_root", &self.chain_root)
            .field("transaction_id", &self.transaction_id)
            .field("purpose", &self.purpose)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("prv_txn_id", &prv_txn_id)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(super) fn new(
        chain_root: &[u8], transaction_id: &[u8], slot_no: u64, txn: i16, cip509: &Cip509,
    ) -> Self {
        Params {
            chain_root: chain_root.to_vec(),
            transaction_id: transaction_id.to_vec(),
            purpose: cip509.purpose.into(),
            slot_no: num_bigint::BigInt::from(slot_no),
            txn,
            prv_txn_id: if let Some(tx_id) = cip509.prv_tx_id {
                MaybeUnset::Set(tx_id.to_vec())
            } else {
                MaybeUnset::Unset
            },
        }
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_RBAC509_QUERY,
            cfg,
            scylla::statement::Consistency::LocalQuorum,
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
