//! Insert invalid RBAC 509 Registration Query.

use std::{fmt::Debug, sync::Arc};

use catalyst_types::problem_report::ProblemReport;
use rbac_registration::cardano::cip509::Cip509;
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbCatalystId, DbSlot, DbTransactionHash, DbTxnIndex, DbUuidV4},
    },
    settings::cassandra_db::EnvVars,
};

/// A RBAC registration indexing query.
const INSERT_QUERY: &str = include_str!("./cql/insert_rbac509_invalid.cql");

/// Insert an invalid RBAC registration query parameters.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A Catalyst short identifier.
    catalyst_id: DbCatalystId,
    /// A transaction hash of this registration.
    transaction_id: DbTransactionHash,
    /// A block slot number.
    slot_no: DbSlot,
    /// A transaction offset inside the block.
    txn: DbTxnIndex,
    /// A Hash of the previous transaction.
    prv_txn_id: MaybeUnset<DbTransactionHash>,
    /// A registration purpose.
    purpose: MaybeUnset<DbUuidV4>,
    /// JSON encoded `ProblemReport`.
    problem_report: String,
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        catalyst_id: DbCatalystId, transaction_id: DbTransactionHash, slot_no: DbSlot,
        txn: DbTxnIndex, purpose: Option<DbUuidV4>, prv_txn_id: Option<DbTransactionHash>,
        report: ProblemReport,
    ) -> Self {
        let purpose = purpose.map(MaybeUnset::Set).unwrap_or(MaybeUnset::Unset);
        let prv_txn_id = prv_txn_id.map(MaybeUnset::Set).unwrap_or(MaybeUnset::Unset);
        let problem_report = serde_json::to_string(&report).unwrap_or_else(|e| {
            error!("Failed to serialize problem report: {e:?}. Report = {report:?}");
            "".into()
        });

        Self {
            catalyst_id,
            transaction_id,
            purpose,
            slot_no,
            txn,
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
            INSERT_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error,"Failed to prepare Insert RBAC 509 Registration Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_QUERY}"))
    }
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let prv_txn_id = match self.prv_txn_id {
            MaybeUnset::Unset => "UNSET".to_owned(),
            MaybeUnset::Set(v) => format!("{v:?}"),
        };
        let purpose = match self.purpose {
            MaybeUnset::Unset => "UNSET".to_owned(),
            MaybeUnset::Set(v) => format!("{v:?}"),
        };
        f.debug_struct("Params")
            .field("catalyst_id", &self.catalyst_id)
            .field("transaction_id", &self.transaction_id)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("prv_txn_id", &prv_txn_id)
            .field("purpose", &purpose)
            .finish()
    }
}
