//! Insert invalid RBAC 509 Registration Query.

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::{Slot, TransactionId, TxnIndex};
use catalyst_types::{id_uri::IdUri, problem_report::ProblemReport, uuid::UuidV4};
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbCatalystId, DbSlot, DbTransactionId, DbTxnIndex, DbUuidV4},
    },
    settings::cassandra_db::EnvVars,
};

/// A RBAC registration indexing query.
const QUERY: &str = include_str!("cql/insert_rbac509_invalid.cql");

/// Insert an invalid RBAC registration query parameters.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A Catalyst short identifier.
    catalyst_id: DbCatalystId,
    /// A transaction hash of this registration.
    txn_id: DbTransactionId,
    /// A block slot number.
    slot_no: DbSlot,
    /// A transaction offset inside the block.
    txn_index: DbTxnIndex,
    /// A Hash of the previous transaction.
    prv_txn_id: MaybeUnset<DbTransactionId>,
    /// A registration purpose.
    purpose: MaybeUnset<DbUuidV4>,
    /// JSON encoded `ProblemReport`.
    problem_report: String,
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        catalyst_id: IdUri, txn_id: TransactionId, slot_no: Slot, txn_index: TxnIndex,
        purpose: Option<UuidV4>, prv_txn_id: Option<TransactionId>, report: &ProblemReport,
    ) -> Self {
        let purpose = purpose.map_or(MaybeUnset::Unset, |v| MaybeUnset::Set(v.into()));
        let prv_txn_id = prv_txn_id.map_or(MaybeUnset::Unset, |v| MaybeUnset::Set(v.into()));
        let problem_report = serde_json::to_string(&report).unwrap_or_else(|e| {
            error!("Failed to serialize problem report: {e:?}. Report = {report:?}");
            String::new()
        });

        Self {
            catalyst_id: catalyst_id.into(),
            txn_id: txn_id.into(),
            purpose,
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            prv_txn_id,
            problem_report,
        }
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
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
            |error| error!(error=%error,"Failed to prepare Insert Invalid RBAC 509 Registration Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{QUERY}"))
    }
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let prv_txn_id = match self.prv_txn_id {
            MaybeUnset::Unset => "UNSET".to_owned(),
            MaybeUnset::Set(v) => format!("{v}"),
        };
        let purpose = match self.purpose {
            MaybeUnset::Unset => "UNSET".to_owned(),
            MaybeUnset::Set(v) => format!("{}", UuidV4::from(v)),
        };
        f.debug_struct("Params")
            .field("catalyst_id", &self.catalyst_id)
            .field("txn_id", &self.txn_id)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("prv_txn_id", &prv_txn_id)
            .field("purpose", &purpose)
            .field("problem_report", &self.problem_report)
            .finish()
    }
}
