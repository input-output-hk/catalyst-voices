//! Index RBAC Catalyst ID for Stake Address Insert Query.

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::{Slot, TxnIndex};
use catalyst_types::id_uri::IdUri;
use pallas::ledger::addresses::StakeAddress;
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbCatalystId, DbCip19StakeAddress, DbSlot, DbTxnIndex},
    },
    settings::cassandra_db::EnvVars,
};

/// Index RBAC Catalyst ID by Stake Address.
const QUERY: &str = include_str!("cql/insert_catalyst_id_for_stake_address.cql");

/// Insert Catalyst ID For Stake Address Query Parameters
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A stake address.
    stake_address: DbCip19StakeAddress,
    /// A block slot number.
    slot_no: DbSlot,
    /// A transaction offset inside the block.
    txn_index: DbTxnIndex,
    /// A Catalyst short identifier.
    catalyst_id: DbCatalystId,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("catalyst_id", &self.catalyst_id)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        stake_address: StakeAddress, slot_no: Slot, txn_index: TxnIndex, catalyst_id: IdUri,
    ) -> Self {
        Params {
            stake_address: stake_address.into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            catalyst_id: catalyst_id.into(),
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
        .inspect_err(|error| error!(error=%error, "Failed to prepare Insert Catalyst ID For Stake Address Query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{QUERY}"))
    }
}
