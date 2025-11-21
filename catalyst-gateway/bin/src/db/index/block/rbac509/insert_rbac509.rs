//! Insert RBAC 509 Registration Query.

use std::{fmt::Debug, sync::Arc};

use cardano_chain_follower::{Slot, TxnIndex, hashes::TransactionId};
use catalyst_types::{catalyst_id::CatalystId, uuid::UuidV4};
use scylla::{SerializeRow, client::session::Session, value::MaybeUnset};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{FallibleQueryResults, PreparedQueries, PreparedQuery, SizedBatch},
            session::CassandraSession,
        },
        types::{DbCatalystId, DbSlot, DbTransactionId, DbTxnIndex, DbUuidV4},
    },
    settings::cassandra_db::EnvVars,
};

/// RBAC Registration Indexing query
const QUERY: &str = include_str!("cql/insert_rbac509.cql");

/// Insert RBAC Registration Query Parameters
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A Catalyst short identifier.
    catalyst_id: DbCatalystId,
    /// A block slot number.
    slot_no: DbSlot,
    /// A transaction offset inside the block.
    txn_index: DbTxnIndex,
    /// A transaction hash
    txn_id: DbTransactionId,
    /// Hash of Previous Transaction. Is `None` for the first registration. 32 Bytes.
    prv_txn_id: MaybeUnset<DbTransactionId>,
    /// A registration purpose.
    ///
    /// The value of purpose is `None` if the chain is modified by the registration
    /// belonging to another chain (a stake address has been removed).
    purpose: MaybeUnset<DbUuidV4>,
}

impl Debug for Params {
    fn fmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
    ) -> std::fmt::Result {
        let prv_txn_id = match self.prv_txn_id {
            MaybeUnset::Unset => "UNSET".to_owned(),
            MaybeUnset::Set(ref v) => format!("{v:?}"),
        };
        f.debug_struct("Params")
            .field("catalyst_id", &self.catalyst_id)
            .field("txn_id", &self.txn_id)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("prv_txn_id", &prv_txn_id)
            .field("purpose", &self.purpose)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        catalyst_id: CatalystId,
        txn_id: TransactionId,
        slot_no: Slot,
        txn_index: TxnIndex,
        prv_txn_id: Option<TransactionId>,
        purpose: Option<UuidV4>,
    ) -> Self {
        let prv_txn_id = prv_txn_id.map_or(MaybeUnset::Unset, |v| MaybeUnset::Set(v.into()));
        let purpose = purpose.map_or(MaybeUnset::Unset, |v| MaybeUnset::Set(v.into()));

        Self {
            catalyst_id: catalyst_id.into(),
            txn_id: txn_id.into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            prv_txn_id,
            purpose,
        }
    }

    /// Executes prepared queries as a batch.
    pub(crate) async fn execute_batch(
        session: &Arc<CassandraSession>,
        queries: Vec<Self>,
    ) -> FallibleQueryResults {
        session
            .execute_batch(PreparedQuery::Rbac509InsertQuery, queries)
            .await
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>,
        cfg: &EnvVars,
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
            |error| error!(error=%error,"Failed to prepare Insert RBAC 509 Registration Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{QUERY}"))
    }
}
