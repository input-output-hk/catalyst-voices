//! Index RBAC Chain Root For Stake Address Insert Query.

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::{Slot, StakeAddress, TxnIndex};
use scylla::{SerializeRow, Session};
use tracing::error;

use super::TransactionHash;
use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbStakeAddress, DbTransactionHash, DbTxnIndex},
    },
    settings::cassandra_db::EnvVars,
};

/// Index RBAC Chain Root by Stake Address
const INSERT_CHAIN_ROOT_FOR_STAKE_ADDRESS_QUERY: &str =
    include_str!("./cql/insert_chain_root_for_stake_address.cql");

/// Insert Chain Root For Stake Address Query Parameters
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Stake Address Hash. 32 bytes.
    stake_addr: DbStakeAddress,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: DbTxnIndex,
    /// Chain Root Hash. 32 bytes.
    chain_root: DbTransactionHash,
    /// Chain root slot number
    chain_root_slot: num_bigint::BigInt,
    /// Chain root transaction index
    chain_root_txn: i16,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_addr", &self.stake_addr)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("chain_root", &self.chain_root)
            .field("chain_root_slot", &self.chain_root_slot)
            .field("chain_root_txn", &self.chain_root_txn)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        stake_addr: StakeAddress, slot_no: Slot, txn: TxnIndex, chain_root: TransactionHash,
        chain_root_slot: Slot, chain_root_txn: TxnIndex,
    ) -> Self {
        Params {
            stake_addr: stake_addr.into(),
            slot_no: num_bigint::BigInt::from(slot_no),
            txn: txn.into(),
            chain_root: chain_root.into(),
            chain_root_slot: num_bigint::BigInt::from(chain_root_slot),
            chain_root_txn: chain_root_txn.into(),
        }
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CHAIN_ROOT_FOR_STAKE_ADDRESS_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(|error| error!(error=%error,"Failed to prepare Insert Chain Root For Stake Address Query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_CHAIN_ROOT_FOR_STAKE_ADDRESS_QUERY}"))
    }
}
