//! TXO Assets by Stake Address Queries used in purging data.
use std::{fmt::Debug, sync::Arc};

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, SerializeRow,
    Session,
};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{
                purge::{PreparedDeleteQuery, PreparedQueries, PreparedSelectQuery},
                FallibleQueryResults, SizedBatch,
            },
            session::CassandraSession,
        },
        types::{DbSlot, DbStakeAddress, DbTxnIndex, DbTxnOutputOffset},
    },
    settings::cassandra_db,
};

pub(crate) mod result {
    //! Return values for TXO Assets by Stake Address purge queries.

    use crate::db::types::{DbSlot, DbStakeAddress, DbTxnIndex, DbTxnOutputOffset};

    /// Primary Key Row
    pub(crate) type PrimaryKey = (
        DbStakeAddress,
        DbSlot,
        DbTxnIndex,
        DbTxnOutputOffset,
        Vec<u8>,
        Vec<u8>,
    );
}

/// Select primary keys for TXO Assets by Stake Address.
const SELECT_QUERY: &str = include_str!("./cql/get_txo_assets_by_stake_addr.cql");

/// Primary Key Value.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// Stake Address - Binary 29 bytes.
    pub(crate) stake_address: DbStakeAddress,
    /// Block Slot Number
    pub(crate) slot_no: DbSlot,
    /// Transaction Offset inside the block.
    pub(crate) txn_index: DbTxnIndex,
    /// Transaction Output Offset inside the transaction.
    pub(crate) txo: DbTxnOutputOffset,
    /// Asset Policy Hash - Binary 28 bytes.
    policy_id: Vec<u8>,
    /// Name of the asset, within the Policy.
    asset_name: Vec<u8>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("txo", &self.txo)
            .field("policy_id", &self.policy_id)
            .field("asset_name", &self.asset_name)
            .finish()
    }
}

impl From<result::PrimaryKey> for Params {
    fn from(value: result::PrimaryKey) -> Self {
        Self {
            stake_address: value.0,
            slot_no: value.1,
            txn_index: value.2,
            txo: value.3,
            policy_id: value.4,
            asset_name: value.5,
        }
    }
}
/// Get primary key for TXO Assets by Stake Address query.
pub(crate) struct PrimaryKeyQuery;

impl PrimaryKeyQuery {
    /// Prepares a query to get all TXO Assets by stake address primary keys.
    pub(crate) async fn prepare(session: &Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session.clone(),
            SELECT_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare get TXO Assets by stake address primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{SELECT_QUERY}"))
    }

    /// Executes a query to get all TXO Assets by stake address primary keys.
    pub(crate) async fn execute(
        session: &CassandraSession,
    ) -> anyhow::Result<TypedRowStream<result::PrimaryKey>> {
        let iter = session
            .purge_execute_iter(PreparedSelectQuery::TxoAssets)
            .await?
            .rows_stream::<result::PrimaryKey>()?;

        Ok(iter)
    }
}

/// Delete TXO Assets by Stake Address
const DELETE_QUERY: &str = include_str!("cql/delete_txo_assets_by_stake_address.cql");

/// Delete TXO Assets by Stake Address Query
pub(crate) struct DeleteQuery;

impl DeleteQuery {
    /// Prepare Batch of Delete Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            DELETE_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error, "Failed to prepare delete TXO Assets by stake address primary key query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{DELETE_QUERY}"))
    }

    /// Executes a DELETE Query
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<Params>,
    ) -> FallibleQueryResults {
        let results = session
            .purge_execute_batch(PreparedDeleteQuery::TxoAssets, params)
            .await?;

        Ok(results)
    }
}
