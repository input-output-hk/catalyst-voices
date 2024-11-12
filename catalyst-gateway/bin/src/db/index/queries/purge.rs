//! Queries for purging volatile data.

use std::{fmt::Debug, sync::Arc};

use scylla::{
    prepared_statement::PreparedStatement, serialize::row::SerializeRow,
    transport::iterator::RowIterator, Session,
};

use super::{
    super::block::roll_forward::{PurgeBatches, RollforwardPurgeQuery},
    FallibleQueryResults, SizedBatch,
};
use crate::{
    db::index::block::roll_forward::txo_by_stake_addr::get::TxoByStakeAddressPrimaryKeyQuery,
    settings::cassandra_db,
};

/// All prepared DELETE query statements (purge DB table rows).
#[derive(strum_macros::Display)]
pub(crate) enum PreparedDeleteQuery {
    /// TXO Delete query.
    TxoAda,
    /// TXO Asset Delete query.
    TxoAsset,
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
pub(crate) enum PreparedSelectQuery {
    /// TXO Select query.
    TxoAda,
    /// TXO Asset Select query.
    TxoAsset,
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
    get_txo_purge_queries: PreparedStatement,
    /// TXO Asset Purge Query.
    get_txo_asset_purge_queries: PreparedStatement,
    /// Unstaked TXO Purge Query.
    get_unstaked_txo_purge_queries: PreparedStatement,
    /// Unstaked TXO Asset Purge Query.
    get_unstaked_txo_asset_purge_queries: PreparedStatement,
    /// TXI Purge Query.
    get_txi_purge_queries: PreparedStatement,
    /// TXI Purge Query.
    get_stake_registration_purge_queries: PreparedStatement,
    /// CIP36 Registrations Purge Query.
    get_cip36_registration_purge_queries: PreparedStatement,
    /// CIP36 Registration errors Purge Query.
    get_cip36_registration_error_purge_queries: PreparedStatement,
    /// CIP36 Registration for Stake Address Purge Query.
    get_cip36_registration_for_stake_address_purge_queries: PreparedStatement,
    /// RBAC 509 Registrations Purge Query.
    get_rbac509_registration_purge_queries: PreparedStatement,
    /// Chain Root for TX ID Purge Query..
    get_chain_root_for_txn_id_purge_queries: PreparedStatement,
    /// Chain Root for Role 0 Key Purge Query..
    get_chain_root_for_role0_key_purge_queries: PreparedStatement,
    /// Chain Root for Stake Address Purge Query..
    get_chain_root_for_stake_address_purge_queries: PreparedStatement,
    /// TXO Purge Query.
    txo_purge_queries: SizedBatch,
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
    #[allow(clippy::todo)]
    pub(crate) async fn new(
        session: Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<Self> {
        // We initialize like this, so that all errors preparing querys get shown before aborting.
        let all_purge_queries = RollforwardPurgeQuery::prepare_batch(&session, cfg).await;
        let get_txo_purge_queries = TxoByStakeAddressPrimaryKeyQuery::prepare(&session).await?;
        let PurgeBatches {
            get_txo_asset_purge_queries,
            get_unstaked_txo_purge_queries,
            get_unstaked_txo_asset_purge_queries,
            get_txi_purge_queries,
            get_stake_registration_purge_queries,
            get_cip36_registration_purge_queries,
            get_cip36_registration_error_purge_queries,
            get_cip36_registration_for_stake_address_purge_queries,
            get_rbac509_registration_purge_queries,
            get_chain_root_for_txn_id_purge_queries,
            get_chain_root_for_role0_key_purge_queries,
            get_chain_root_for_stake_address_purge_queries,
            txo_purge_queries,
            txo_asset_purge_queries,
            unstaked_txo_purge_queries,
            unstaked_txo_asset_purge_queries,
            txi_purge_queries,
            stake_registration_purge_queries,
            cip36_registration_purge_queries,
            cip36_registration_error_purge_queries,
            cip36_registration_for_stake_address_purge_queries,
            rbac509_registration_purge_queries,
            chain_root_for_txn_id_purge_queries,
            chain_root_for_role0_key_purge_queries,
            chain_root_for_stake_address_purge_queries,
            ..
        }: PurgeBatches = all_purge_queries?;

        Ok(Self {
            get_txo_purge_queries,
            get_txo_asset_purge_queries,
            get_unstaked_txo_purge_queries,
            get_unstaked_txo_asset_purge_queries,
            get_txi_purge_queries,
            get_stake_registration_purge_queries,
            get_cip36_registration_purge_queries,
            get_cip36_registration_error_purge_queries,
            get_cip36_registration_for_stake_address_purge_queries,
            get_rbac509_registration_purge_queries,
            get_chain_root_for_txn_id_purge_queries,
            get_chain_root_for_role0_key_purge_queries,
            get_chain_root_for_stake_address_purge_queries,
            txo_purge_queries,
            txo_asset_purge_queries,
            unstaked_txo_purge_queries,
            unstaked_txo_asset_purge_queries,
            txi_purge_queries,
            stake_registration_purge_queries,
            cip36_registration_purge_queries,
            cip36_registration_error_purge_queries,
            cip36_registration_for_stake_address_purge_queries,
            rbac509_registration_purge_queries,
            chain_root_for_txn_id_purge_queries,
            chain_root_for_role0_key_purge_queries,
            chain_root_for_stake_address_purge_queries,
        })
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
    pub(crate) async fn execute_iter<P>(
        &self, session: Arc<Session>, select_query: PreparedSelectQuery, params: P,
    ) -> anyhow::Result<RowIterator>
    where P: SerializeRow {
        let prepared_stmt = match select_query {
            PreparedSelectQuery::TxoAda => &self.get_txo_purge_queries,
            PreparedSelectQuery::TxoAsset => &self.get_txo_asset_purge_queries,
            PreparedSelectQuery::UnstakedTxoAda => &self.get_unstaked_txo_purge_queries,
            PreparedSelectQuery::UnstakedTxoAsset => &self.get_unstaked_txo_asset_purge_queries,
            PreparedSelectQuery::Txi => &self.get_txi_purge_queries,
            PreparedSelectQuery::StakeRegistration => &self.get_stake_registration_purge_queries,
            PreparedSelectQuery::Cip36Registration => &self.get_cip36_registration_purge_queries,
            PreparedSelectQuery::Cip36RegistrationError => {
                &self.get_cip36_registration_error_purge_queries
            },
            PreparedSelectQuery::Cip36RegistrationForStakeAddr => {
                &self.get_cip36_registration_for_stake_address_purge_queries
            },
            PreparedSelectQuery::Rbac509 => &self.get_rbac509_registration_purge_queries,
            PreparedSelectQuery::ChainRootForTxnId => &self.get_chain_root_for_txn_id_purge_queries,
            PreparedSelectQuery::ChainRootForRole0Key => {
                &self.get_chain_root_for_role0_key_purge_queries
            },
            PreparedSelectQuery::ChainRootForStakeAddress => {
                &self.get_chain_root_for_stake_address_purge_queries
            },
        };

        super::session_execute_iter(session, prepared_stmt, params).await
    }

    /// Execute a purge query with the given parameters.
    pub(crate) async fn execute<T: SerializeRow + Debug>(
        &self, session: Arc<Session>, cfg: Arc<cassandra_db::EnvVars>, query: PreparedDeleteQuery,
        values: Vec<T>,
    ) -> FallibleQueryResults {
        let query_map = match query {
            PreparedDeleteQuery::TxoAda => &self.txo_purge_queries,
            PreparedDeleteQuery::TxoAsset => &self.txo_asset_purge_queries,
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
