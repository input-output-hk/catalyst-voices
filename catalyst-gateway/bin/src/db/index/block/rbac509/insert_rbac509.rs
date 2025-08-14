//! Insert RBAC 509 Registration Query.

use std::{collections::HashSet, fmt::Debug, sync::Arc};

use cardano_blockchain_types::{hashes::TransactionId, Slot, StakeAddress, TxnIndex};
use catalyst_types::catalyst_id::CatalystId;
use scylla::{client::session::Session, value::MaybeUnset, SerializeRow};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbCatalystId, DbSlot, DbStakeAddress, DbTransactionId, DbTxnIndex},
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
    /// A set of removed stake addresses.
    removed_stake_addresses: HashSet<DbStakeAddress>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
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
            .field("removed_stake_addresses", &self.removed_stake_addresses)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        catalyst_id: CatalystId, txn_id: TransactionId, slot_no: Slot, txn_index: TxnIndex,
        prv_txn_id: Option<TransactionId>, removed_stake_addresses: HashSet<StakeAddress>,
    ) -> Self {
        let prv_txn_id = prv_txn_id.map_or(MaybeUnset::Unset, |v| MaybeUnset::Set(v.into()));
        let removed_stake_addresses = removed_stake_addresses
            .into_iter()
            .map(Into::into)
            .collect();

        Self {
            catalyst_id: catalyst_id.into(),
            txn_id: txn_id.into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            prv_txn_id,
            removed_stake_addresses,
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
            |error| error!(error=%error,"Failed to prepare Insert RBAC 509 Registration Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{QUERY}"))
    }
}
