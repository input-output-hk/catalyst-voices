//! Queries for purging volatile data.

pub(crate) mod txo_ada;

use std::{fmt::Debug, sync::Arc};

use scylla::{
    prepared_statement::PreparedStatement, serialize::row::SerializeRow,
    transport::iterator::RowIterator, Session,
};

use super::{FallibleQueryResults, SizedBatch};
use crate::settings::cassandra_db;

/// No parameters
const NO_PARAMS: () = ();

/// All prepared DELETE query statements (purge DB table rows).
#[derive(strum_macros::Display)]
#[allow(dead_code)]
pub(crate) enum PreparedDeleteQuery {
    /// TXO Delete query.
    TxoAda,
    /// TXO Assets Delete query.
    TxoAssets,
    /// Unstaked TXO Delete query.
    UnstakedTxoAda,
    /// Unstaked TXO Asset Delete query.
    UnstakedTxoAsset,
    /// TXI Delete query.
    Txi,
    /// Stake Registration Delete query.
    StakeRegistration,
    /// CIP 36 Registration Delete Query.
    Cip36Registration,
    /// CIP 36 Registration Error Delete query.
    Cip36RegistrationError,
    /// CIP 36 Registration for stake address Delete query.
    Cip36RegistrationForStakeAddr,
    /// RBAC 509 Registration Delete query.
    Rbac509,
    /// Chain Root For Transaction ID Delete query.
    ChainRootForTxnId,
    /// Chain Root For Role0 Key Delete query.
    ChainRootForRole0Key,
    /// Chain Root For Stake Address Delete query.
    ChainRootForStakeAddress,
}

/// All prepared SELECT query statements (primary keys from table).
#[derive(strum_macros::Display)]
#[allow(dead_code)]
pub(crate) enum PreparedSelectQuery {
    /// TXO Select query.
    TxoAda,
    /// TXO Asset Select query.
    TxoAssets,
    /// Unstaked TXO Select query.
    UnstakedTxoAda,
    /// Unstaked TXO Asset Select query.
    UnstakedTxoAsset,
    /// TXI Select query.
    Txi,
    /// Stake Registration Select query.
    StakeRegistration,
    /// CIP 36 Registration Select Query.
    Cip36Registration,
    /// CIP 36 Registration Error Select query.
    Cip36RegistrationError,
    /// CIP 36 Registration for stake address Select query.
    Cip36RegistrationForStakeAddr,
    /// RBAC 509 Registration Select query.
    Rbac509,
    /// Chain Root For Transaction ID Select query.
    ChainRootForTxnId,
    /// Chain Root For Role0 Key Select query.
    ChainRootForRole0Key,
    /// Chain Root For Stake Address Select query.
    ChainRootForStakeAddress,
}

/// All prepared purge queries for a session.
#[allow(clippy::struct_field_names)]
pub(crate) struct PreparedQueries {
    /// TXO Purge Query.
    select_txo_ada: PreparedStatement,
    /// TXO Asset Purge Query.
    select_txo_assets: PreparedStatement,
    /// Unstaked TXO Purge Query.
    select_unstaked_txo_purge_queries: PreparedStatement,
    /// Unstaked TXO Asset Purge Query.
    select_unstaked_txo_asset_purge_queries: PreparedStatement,
    /// TXI Purge Query.
    select_txi_purge_queries: PreparedStatement,
    /// TXI Purge Query.
    select_stake_registration_purge_queries: PreparedStatement,
    /// CIP36 Registrations Purge Query.
    select_cip36_registration_purge_queries: PreparedStatement,
    /// CIP36 Registration errors Purge Query.
    select_cip36_registration_error_purge_queries: PreparedStatement,
    /// CIP36 Registration for Stake Address Purge Query.
    select_cip36_registration_for_stake_address_purge_queries: PreparedStatement,
    /// RBAC 509 Registrations Purge Query.
    select_rbac509_registration_purge_queries: PreparedStatement,
    /// Chain Root for TX ID Purge Query..
    select_chain_root_for_txn_id_purge_queries: PreparedStatement,
    /// Chain Root for Role 0 Key Purge Query..
    select_chain_root_for_role0_key_purge_queries: PreparedStatement,
    /// Chain Root for Stake Address Purge Query..
    select_chain_root_for_stake_address_purge_queries: PreparedStatement,
    /// TXO Purge Query.
    delete_txo_ada: SizedBatch,
    /// TXO Asset Purge Query.
    txo_asset_purge_queries: SizedBatch,
    /// Unstaked TXO Purge Query.
    unstaked_txo_purge_queries: SizedBatch,
    /// Unstaked TXO Asset Purge Query.
    unstaked_txo_asset_purge_queries: SizedBatch,
    /// TXI Purge Query.
    txi_purge_queries: SizedBatch,
    /// TXI Purge Query.
    stake_registration_purge_queries: SizedBatch,
    /// CIP36 Registrations Purge Query.
    cip36_registration_purge_queries: SizedBatch,
    /// CIP36 Registration errors Purge Query.
    cip36_registration_error_purge_queries: SizedBatch,
    /// CIP36 Registration for Stake Address Purge Query.
    cip36_registration_for_stake_address_purge_queries: SizedBatch,
    /// RBAC 509 Registrations Purge Query.
    rbac509_registration_purge_queries: SizedBatch,
    /// Chain Root for TX ID Purge Query..
    chain_root_for_txn_id_purge_queries: SizedBatch,
    /// Chain Root for Role 0 Key Purge Query..
    chain_root_for_role0_key_purge_queries: SizedBatch,
    /// Chain Root for Stake Address Purge Query..
    chain_root_for_stake_address_purge_queries: SizedBatch,
}

impl PreparedQueries {
    /// Create new prepared queries for a given session.
    #[allow(clippy::todo, clippy::no_effect_underscore_binding, unused_variables)]
    pub(crate) async fn new(
        session: Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<Self> {
        // We initialize like this, so that all errors preparing querys get shown before aborting.
        let select_txo_ada = txo_ada::PrimaryKeyQuery::prepare(&session).await?;
        let delete_txo_ada = txo_ada::DeleteQuery::prepare_batch(&session, cfg).await?;

        todo!("WIP");
    }

    /// Prepares a statement.
    pub(crate) async fn prepare(
        session: Arc<Session>, query: &str, consistency: scylla::statement::Consistency,
        idempotent: bool,
    ) -> anyhow::Result<PreparedStatement> {
        super::PreparedQueries::prepare(session, query, consistency, idempotent).await
    }

    /// Prepares all permutations of the batch from 1 to max.
    /// It is necessary to do this because batches are pre-sized, they can not be dynamic.
    /// Preparing the batches in advance is a very larger performance increase.
    pub(crate) async fn prepare_batch(
        session: Arc<Session>, query: &str, cfg: &cassandra_db::EnvVars,
        consistency: scylla::statement::Consistency, idempotent: bool, logged: bool,
    ) -> anyhow::Result<SizedBatch> {
        super::PreparedQueries::prepare_batch(session, query, cfg, consistency, idempotent, logged)
            .await
    }

    /// Executes a select query with the given parameters.
    ///
    /// Returns an iterator that iterates over all the result pages that the query
    /// returns.
    pub(crate) async fn execute_iter(
        &self, session: Arc<Session>, select_query: PreparedSelectQuery,
    ) -> anyhow::Result<RowIterator> {
        let prepared_stmt = match select_query {
            PreparedSelectQuery::TxoAda => &self.select_txo_ada,
            PreparedSelectQuery::TxoAssets => &self.select_txo_assets,
            PreparedSelectQuery::UnstakedTxoAda => &self.get_unstaked_txo_purge_queries,
            PreparedSelectQuery::UnstakedTxoAsset => &self.select_unstaked_txo_asset_purge_queries,
            PreparedSelectQuery::Txi => &self.select_txi_purge_queries,
            PreparedSelectQuery::StakeRegistration => &self.select_stake_registration_purge_queries,
            PreparedSelectQuery::Cip36Registration => &self.select_cip36_registration_purge_queries,
            PreparedSelectQuery::Cip36RegistrationError => {
                &self.select_cip36_registration_error_purge_queries
            },
            PreparedSelectQuery::Cip36RegistrationForStakeAddr => {
                &self.select_cip36_registration_for_stake_address_purge_queries
            },
            PreparedSelectQuery::Rbac509 => &self.select_rbac509_registration_purge_queries,
            PreparedSelectQuery::ChainRootForTxnId => {
                &self.select_chain_root_for_txn_id_purge_queries
            },
            PreparedSelectQuery::ChainRootForRole0Key => {
                &self.select_chain_root_for_role0_key_purge_queries
            },
            PreparedSelectQuery::ChainRootForStakeAddress => {
                &self.select_chain_root_for_stake_address_purge_queries
            },
        };

        super::session_execute_iter(session, prepared_stmt, NO_PARAMS).await
    }

    /// Execute a purge query with the given parameters.
    pub(crate) async fn execute_batch<T: SerializeRow + Debug>(
        &self, session: Arc<Session>, cfg: Arc<cassandra_db::EnvVars>, query: PreparedDeleteQuery,
        values: Vec<T>,
    ) -> FallibleQueryResults {
        let query_map = match query {
            PreparedDeleteQuery::TxoAda => &self.delete_txo_ada,
            PreparedDeleteQuery::TxoAssets => &self.txo_asset_purge_queries,
            PreparedDeleteQuery::UnstakedTxoAda => &self.unstaked_txo_purge_queries,
            PreparedDeleteQuery::UnstakedTxoAsset => &self.unstaked_txo_asset_purge_queries,
            PreparedDeleteQuery::Txi => &self.txi_purge_queries,
            PreparedDeleteQuery::StakeRegistration => &self.stake_registration_purge_queries,
            PreparedDeleteQuery::Cip36Registration => &self.cip36_registration_purge_queries,
            PreparedDeleteQuery::Cip36RegistrationError => {
                &self.cip36_registration_error_purge_queries
            },
            PreparedDeleteQuery::Cip36RegistrationForStakeAddr => {
                &self.cip36_registration_for_stake_address_purge_queries
            },
            PreparedDeleteQuery::Rbac509 => &self.rbac509_registration_purge_queries,
            PreparedDeleteQuery::ChainRootForTxnId => &self.chain_root_for_txn_id_purge_queries,
            PreparedDeleteQuery::ChainRootForRole0Key => {
                &self.chain_root_for_role0_key_purge_queries
            },
            PreparedDeleteQuery::ChainRootForStakeAddress => {
                &self.chain_root_for_stake_address_purge_queries
            },
        };

        super::session_execute_batch(session, query_map, cfg, query, values).await
    }
}
