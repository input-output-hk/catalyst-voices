//! Index RBAC Chain Root For Stake Address Insert Query.

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::{Slot, StakeAddress, TxnIndex};
use scylla::{SerializeRow, Session};
use tracing::error;

use super::TransactionHash;
use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbCatalystId, DbSlot, DbStakeAddress, DbTransactionHash, DbTxnIndex},
    },
    settings::cassandra_db::EnvVars,
};

/// Index RBAC Chain Root by Stake Address
const INSERT_QUERY: &str = include_str!("cql/insert_catalyst_id_for_stake_address.cql");

/// Insert Chain Root For Stake Address Query Parameters
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Stake Address Hash. 32 bytes.
    stake_addr: DbStakeAddress,
    /// Block Slot Number
    slot_no: DbSlot,
    /// Transaction Offset inside the block.
    txn: DbTxnIndex,
    /// A Catalyst short identifier.
    catalyst_id: DbCatalystId,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_addr", &self.stake_addr)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("catalyst_id", &self.catalyst_id)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        stake_addr: DbStakeAddress, slot_no: DbSlot, txn: DbTxnIndex, catalyst_id: DbCatalystId,
    ) -> Self {
        Params {
            stake_addr,
            slot_no,
            txn,
            catalyst_id,
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
        .inspect_err(|error| error!(error=%error,"Failed to prepare Insert Chain Root For Stake Address Query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_QUERY}"))
    }
}
