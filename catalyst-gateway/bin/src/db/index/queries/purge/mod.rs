//! Queries for purging volatile data.

pub(crate) mod txo_ada;
pub(crate) mod txo_assets;
pub(crate) mod unstaked_txo_ada;
pub(crate) mod unstaked_txo_assets;

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
    /// TXI by TXN Hash Delete query.
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
    /// TXI by TXN Hash Select query.
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
#[allow(dead_code)]
pub(crate) struct PreparedQueries {
    /// TXO ADA Primary Key Query.
    select_txo_ada: PreparedStatement,
    /// TXO Delete Query.
    delete_txo_ada: SizedBatch,
    /// TXO Asset Primary Key Query.
    select_txo_assets: PreparedStatement,
    /// TXO Assets Delete Query.
    delete_txo_assets: SizedBatch,
    /// Unstaked TXO ADA Primary Key Query.
    select_unstaked_txo_ada: PreparedStatement,
    /// Unstaked TXO Assets Primary Key Query.
    select_unstaked_txo_assets: PreparedStatement,
    /// TXI by TXN Hash by TXN Hash Primary Key Query.
    select_txi_by_hash: PreparedStatement,
    /// Stake Registration Primary Key Query.
    select_stake_registration: PreparedStatement,
    /// CIP36 Registrations Primary Key Query.
    select_cip36_registration: PreparedStatement,
    /// CIP36 Registration errors Primary Key Query.
    select_cip36_registration_error: PreparedStatement,
    /// CIP36 Registration for Stake Address Primary Key Query.
    select_cip36_registration_for_stake_address: PreparedStatement,
    /// RBAC 509 Registrations Primary Key Query.
    select_rbac509_registration: PreparedStatement,
    /// Chain Root for TX ID Primary Key Query..
    select_chain_root_for_txn_id: PreparedStatement,
    /// Chain Root for Role 0 Key Primary Key Query..
    select_chain_root_for_role0_key: PreparedStatement,
    /// Chain Root for Stake Address Primary Key Query..
    select_chain_root_for_stake_address: PreparedStatement,
    /// Unstaked TXO ADA Delete Query.
    delete_unstaked_txo_ada: SizedBatch,
    /// Unstaked TXO Asset Delete Query.
    delete_unstaked_txo_assets: SizedBatch,
    /// TXI by TXN Hash Delete Query.
    delete_txi: SizedBatch,
    /// Stake Registration Delete Query.
    delete_stake_registration: SizedBatch,
    /// CIP36 Registrations Delete Query.
    delete_cip36_registration: SizedBatch,
    /// CIP36 Registration errors Delete Query.
    delete_cip36_registration_error: SizedBatch,
    /// CIP36 Registration for Stake Address Delete Query.
    delete_cip36_registration_for_stake_addr: SizedBatch,
    /// RBAC 509 Registrations Delete Query.
    delete_rbac509_registration: SizedBatch,
    /// Chain Root for TX ID Delete Query..
    delete_chain_root_for_txn_id: SizedBatch,
    /// Chain Root for Role 0 Key Delete Query..
    delete_chain_root_for_role0_key: SizedBatch,
    /// Chain Root for Stake Address Delete Query..
    delete_chain_root_for_stake_address: SizedBatch,
}

impl PreparedQueries {
    /// Create new prepared queries for a given session.
    #[allow(clippy::todo, unused_variables)]
    pub(crate) async fn new(
        session: Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<Self> {
        // We initialize like this, so that all errors preparing querys get shown before aborting.
        let select_txo_ada = txo_ada::PrimaryKeyQuery::prepare(&session).await?;
        let delete_txo_ada = txo_ada::DeleteQuery::prepare_batch(&session, cfg).await?;
        let select_txo_assets = txo_assets::PrimaryKeyQuery::prepare(&session).await?;
        let delete_txo_assets = txo_assets::DeleteQuery::prepare_batch(&session, cfg).await?;
        let select_unstaked_txo_ada = unstaked_txo_ada::PrimaryKeyQuery::prepare(&session).await?;
        let delete_unstaked_txo_ada =
            unstaked_txo_ada::DeleteQuery::prepare_batch(&session, cfg).await?;
        let select_unstaked_txo_assets =
            unstaked_txo_assets::PrimaryKeyQuery::prepare(&session).await?;
        let delete_unstaked_txo_assets =
            unstaked_txo_assets::DeleteQuery::prepare_batch(&session, cfg).await?;

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
            PreparedSelectQuery::UnstakedTxoAda => &self.select_unstaked_txo_ada,
            PreparedSelectQuery::UnstakedTxoAsset => &self.select_unstaked_txo_assets,
            PreparedSelectQuery::Txi => &self.select_txi_by_hash,
            PreparedSelectQuery::StakeRegistration => &self.select_stake_registration,
            PreparedSelectQuery::Cip36Registration => &self.select_cip36_registration,
            PreparedSelectQuery::Cip36RegistrationError => &self.select_cip36_registration_error,
            PreparedSelectQuery::Cip36RegistrationForStakeAddr => {
                &self.select_cip36_registration_for_stake_address
            },
            PreparedSelectQuery::Rbac509 => &self.select_rbac509_registration,
            PreparedSelectQuery::ChainRootForTxnId => &self.select_chain_root_for_txn_id,
            PreparedSelectQuery::ChainRootForRole0Key => &self.select_chain_root_for_role0_key,
            PreparedSelectQuery::ChainRootForStakeAddress => {
                &self.select_chain_root_for_stake_address
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
            PreparedDeleteQuery::TxoAssets => &self.delete_txo_assets,
            PreparedDeleteQuery::UnstakedTxoAda => &self.delete_unstaked_txo_ada,
            PreparedDeleteQuery::UnstakedTxoAsset => &self.delete_unstaked_txo_assets,
            PreparedDeleteQuery::Txi => &self.delete_txi,
            PreparedDeleteQuery::StakeRegistration => &self.delete_stake_registration,
            PreparedDeleteQuery::Cip36Registration => &self.delete_cip36_registration,
            PreparedDeleteQuery::Cip36RegistrationError => &self.delete_cip36_registration_error,
            PreparedDeleteQuery::Cip36RegistrationForStakeAddr => {
                &self.delete_cip36_registration_for_stake_addr
            },
            PreparedDeleteQuery::Rbac509 => &self.delete_rbac509_registration,
            PreparedDeleteQuery::ChainRootForTxnId => &self.delete_chain_root_for_txn_id,
            PreparedDeleteQuery::ChainRootForRole0Key => &self.delete_chain_root_for_role0_key,
            PreparedDeleteQuery::ChainRootForStakeAddress => {
                &self.delete_chain_root_for_stake_address
            },
        };

        super::session_execute_batch(session, query_map, cfg, query, values).await
    }
}
