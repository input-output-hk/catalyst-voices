//! Index RBAC Catalyst ID For Transaction ID Insert Query.

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::{Slot, TransactionHash, TxnIndex};
use catalyst_types::id_uri::IdUri;
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbCatalystId, DbSlot, DbTransactionId, DbTxnIndex},
    },
    settings::cassandra_db::EnvVars,
};

/// Index RBAC Catalyst ID by TX ID.
const QUERY: &str = include_str!("cql/insert_catalyst_id_for_txn_id.cql");

/// Insert Catalyst ID For Transaction ID Query Parameters
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A transaction hash.
    txn_id: DbTransactionId,
    /// A Catalyst short identifier.
    catalyst_id: DbCatalystId,
    /// A slot number.
    slot_no: DbSlot,
    /// A transaction offset inside the block.
    txn_index: DbTxnIndex,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("txn_id", &self.txn_id)
            .field("catalyst_id", &self.catalyst_id)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .finish()
    }
}

impl Params {
    /// Creates a new record for this transaction.
    pub(crate) fn new(
        catalyst_id: IdUri, txn_id: TransactionHash, slot_no: Slot, txn_index: TxnIndex,
    ) -> Self {
        Params {
            txn_id: txn_id.into(),
            catalyst_id: catalyst_id.into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
        }
    }

    /// Prepares a Batch of RBAC Registration Index Data Queries.
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error,"Failed to prepare Insert Catalyst ID For TXN ID Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{QUERY}"))
    }
}
