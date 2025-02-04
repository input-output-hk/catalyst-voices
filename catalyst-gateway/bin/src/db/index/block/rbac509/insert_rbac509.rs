//! Insert RBAC 509 Registration Query.

use std::{fmt::Debug, sync::Arc};

use rbac_registration::cardano::cip509::Cip509;
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbTransactionHash, DbTxnIndex, DbUuidV4},
    },
    settings::cassandra_db::EnvVars,
};

/// RBAC Registration Indexing query
const INSERT_RBAC509_QUERY: &str = include_str!("./cql/insert_rbac509.cql");

/// Insert RBAC Registration Query Parameters
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A Catalyst short identifier.
    catalyst_id: String,
    /// Transaction ID Hash. 32 bytes.
    transaction_id: DbTransactionHash,
    /// Block Slot Number
    slot_no: DbSlot,
    /// Transaction Offset inside the block.
    txn: DbTxnIndex,
    /// Hash of Previous Transaction. Is `None` for the first registration. 32 Bytes.
    prv_txn_id: MaybeUnset<DbTransactionHash>,
    /// Purpose.`UUIDv4`. 16 bytes.
    purpose: DbUuidV4,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let prv_txn_id = match self.prv_txn_id {
            MaybeUnset::Unset => "UNSET".to_owned(),
            MaybeUnset::Set(ref v) => format!("{v:?}"),
        };
        f.debug_struct("Params")
            .field("catalyst_id", &self.catalyst_id)
            .field("transaction_id", &self.transaction_id)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("prv_txn_id", &prv_txn_id)
            .field("purpose", &self.purpose)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        catalyst_id: String, transaction_id: DbTransactionHash, slot_no: DbSlot, txn: DbTxnIndex,
        purpose: DbUuidV4, prv_txn_id: Option<DbTransactionHash>,
    ) -> Self {
        let prv_txn_id = prv_txn_id.map(MaybeUnset::Set).unwrap_or(MaybeUnset::Unset);

        Self {
            catalyst_id,
            transaction_id,
            purpose,
            slot_no,
            txn,
            prv_txn_id,
        }
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_RBAC509_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error,"Failed to prepare Insert RBAC 509 Registration Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_RBAC509_QUERY}"))
    }
}
