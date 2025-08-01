//! Queries for purging volatile data.

pub(crate) mod catalyst_id_for_public_key;
pub(crate) mod catalyst_id_for_stake_address;
pub(crate) mod catalyst_id_for_txn_id;
pub(crate) mod cip36_registration;
pub(crate) mod cip36_registration_for_vote_key;
pub(crate) mod cip36_registration_invalid;
pub(crate) mod rbac509_invalid_registration;
pub(crate) mod rbac509_registration;
pub(crate) mod stake_registration;
pub(crate) mod txi_by_hash;
pub(crate) mod txo_ada;
pub(crate) mod txo_assets;
pub(crate) mod unstaked_txo_ada;
pub(crate) mod unstaked_txo_assets;

use std::{fmt::Debug, sync::Arc};

use scylla::{
    client::{pager::QueryPager, session::Session},
    serialize::row::SerializeRow,
    statement::prepared::PreparedStatement,
};

use super::{FallibleQueryResults, SizedBatch};
use crate::settings::cassandra_db;

/// No parameters
const NO_PARAMS: () = ();

/// All prepared DELETE query statements (purge DB table rows).
#[derive(strum_macros::Display)]
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
    /// CIP 36 Registration Invalid Delete query.
    Cip36RegistrationInvalid,
    /// CIP 36 Registration for vote key Delete query.
    Cip36RegistrationForVoteKey,
    /// RBAC 509 Registration Delete query.
    Rbac509,
    /// Invalid RBAC 509 Registration Delete query.
    Rbac509Invalid,
    /// Catalyst ID for transaction ID delete query.
    CatalystIdForTxnId,
    /// Catalyst ID for stake address delete query.
    CatalystIdForStakeAddress,
    /// Catalyst ID for public key delete query.
    CatalystIdForPublicKey,
}

/// All prepared SELECT query statements (primary keys from table).
#[derive(strum_macros::Display)]
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
    /// CIP 36 Registration Invalid Select query.
    Cip36RegistrationInvalid,
    /// CIP 36 Registration for vote key Select query.
    Cip36RegistrationForVoteKey,
    /// RBAC 509 Registration Select query.
    Rbac509,
    /// Invalid RBAC 509 Registration Select query.
    Rbac509Invalid,
    /// Catalyst ID for transaction ID select query.
    CatalystIdForTxnId,
    /// Catalyst ID for stake address select query.
    CatalystIdForStakeAddress,
    /// Catalyst ID for public key select query.
    CatalystIdForPublicKey,
}

/// All prepared purge queries for a session.
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
    /// Unstaked TXO ADA Delete Query.
    delete_unstaked_txo_ada: SizedBatch,
    /// Unstaked TXO Assets Primary Key Query.
    select_unstaked_txo_assets: PreparedStatement,
    /// Unstaked TXO Asset Delete Query.
    delete_unstaked_txo_assets: SizedBatch,
    /// TXI by TXN Hash by TXN Hash Primary Key Query.
    select_txi_by_hash: PreparedStatement,
    /// TXI by TXN Hash Delete Query.
    delete_txi_by_hash: SizedBatch,
    /// Stake Registration Primary Key Query.
    select_stake_registration: PreparedStatement,
    /// Stake Registration Delete Query.
    delete_stake_registration: SizedBatch,
    /// CIP36 Registrations Primary Key Query.
    select_cip36_registration: PreparedStatement,
    /// CIP36 Registrations Delete Query.
    delete_cip36_registration: SizedBatch,
    /// CIP36 Registration Invalid Primary Key Query.
    select_cip36_registration_invalid: PreparedStatement,
    /// CIP36 Registration Invalid Delete Query.
    delete_cip36_registration_invalid: SizedBatch,
    /// CIP36 Registration for Vote Key Primary Key Query.
    select_cip36_registration_for_vote_key: PreparedStatement,
    /// CIP36 Registration for Vote Key Delete Query.
    delete_cip36_registration_for_vote_key: SizedBatch,
    /// RBAC 509 Registrations Primary Key Query.
    select_rbac509_registration: PreparedStatement,
    /// RBAC 509 Registrations Delete Query.
    delete_rbac509_registration: SizedBatch,
    /// RBAC 509 invalid registrations Primary Key Query.
    select_rbac509_invalid_registration: PreparedStatement,
    /// RBAC 509 invalid registrations Delete Query.
    delete_rbac509_invalid_registration: SizedBatch,
    /// A Catalyst ID for transaction ID primary key query.
    select_catalyst_id_for_txn_id: PreparedStatement,
    /// A Catalyst ID for transaction ID delete query.
    delete_catalyst_id_for_txn_id: SizedBatch,
    /// A Catalyst ID for stake address primary key query.
    select_catalyst_id_for_stake_address: PreparedStatement,
    /// A Catalyst ID for stake address delete query.
    delete_catalyst_id_for_stake_address: SizedBatch,
    /// A Catalyst ID for public key primary key query.
    select_catalyst_id_for_public_key: PreparedStatement,
    /// A Catalyst ID for public key delete query.
    delete_catalyst_id_for_public_key: SizedBatch,
}

impl PreparedQueries {
    /// Create new prepared queries for a given session.
    pub(crate) async fn new(
        session: Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<Self> {
        // We initialize like this, so that all errors preparing querys get shown before aborting.
        Ok(Self {
            select_txo_ada: txo_ada::PrimaryKeyQuery::prepare(&session).await?,
            delete_txo_ada: txo_ada::DeleteQuery::prepare_batch(&session, cfg).await?,
            select_txo_assets: txo_assets::PrimaryKeyQuery::prepare(&session).await?,
            delete_txo_assets: txo_assets::DeleteQuery::prepare_batch(&session, cfg).await?,
            select_unstaked_txo_ada: unstaked_txo_ada::PrimaryKeyQuery::prepare(&session).await?,
            delete_unstaked_txo_ada: unstaked_txo_ada::DeleteQuery::prepare_batch(&session, cfg)
                .await?,
            select_unstaked_txo_assets: unstaked_txo_assets::PrimaryKeyQuery::prepare(&session)
                .await?,
            delete_unstaked_txo_assets: unstaked_txo_assets::DeleteQuery::prepare_batch(
                &session, cfg,
            )
            .await?,
            select_txi_by_hash: txi_by_hash::PrimaryKeyQuery::prepare(&session).await?,
            delete_txi_by_hash: txi_by_hash::DeleteQuery::prepare_batch(&session, cfg).await?,
            select_stake_registration: stake_registration::PrimaryKeyQuery::prepare(&session)
                .await?,
            delete_stake_registration: stake_registration::DeleteQuery::prepare_batch(
                &session, cfg,
            )
            .await?,
            select_cip36_registration: cip36_registration::PrimaryKeyQuery::prepare(&session)
                .await?,
            delete_cip36_registration: cip36_registration::DeleteQuery::prepare_batch(
                &session, cfg,
            )
            .await?,
            select_cip36_registration_invalid:
                cip36_registration_invalid::PrimaryKeyQuery::prepare(&session).await?,
            delete_cip36_registration_invalid:
                cip36_registration_invalid::DeleteQuery::prepare_batch(&session, cfg).await?,
            select_cip36_registration_for_vote_key:
                cip36_registration_for_vote_key::PrimaryKeyQuery::prepare(&session).await?,
            delete_cip36_registration_for_vote_key:
                cip36_registration_for_vote_key::DeleteQuery::prepare_batch(&session, cfg).await?,
            select_rbac509_registration: rbac509_registration::PrimaryKeyQuery::prepare(&session)
                .await?,
            delete_rbac509_registration: rbac509_registration::DeleteQuery::prepare_batch(
                &session, cfg,
            )
            .await?,
            select_rbac509_invalid_registration:
                rbac509_invalid_registration::PrimaryKeyQuery::prepare(&session).await?,
            delete_rbac509_invalid_registration:
                rbac509_invalid_registration::DeleteQuery::prepare_batch(&session, cfg).await?,
            select_catalyst_id_for_txn_id: catalyst_id_for_txn_id::PrimaryKeyQuery::prepare(
                &session,
            )
            .await?,
            delete_catalyst_id_for_txn_id: catalyst_id_for_txn_id::DeleteQuery::prepare_batch(
                &session, cfg,
            )
            .await?,
            select_catalyst_id_for_stake_address:
                catalyst_id_for_stake_address::PrimaryKeyQuery::prepare(&session).await?,
            delete_catalyst_id_for_stake_address:
                catalyst_id_for_stake_address::DeleteQuery::prepare_batch(&session, cfg).await?,
            select_catalyst_id_for_public_key:
                catalyst_id_for_public_key::PrimaryKeyQuery::prepare(&session).await?,
            delete_catalyst_id_for_public_key:
                catalyst_id_for_public_key::DeleteQuery::prepare_batch(&session, cfg).await?,
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
    pub(crate) async fn execute_iter(
        &self, session: Arc<Session>, select_query: PreparedSelectQuery,
    ) -> anyhow::Result<QueryPager> {
        let prepared_stmt = match select_query {
            PreparedSelectQuery::TxoAda => &self.select_txo_ada,
            PreparedSelectQuery::TxoAssets => &self.select_txo_assets,
            PreparedSelectQuery::UnstakedTxoAda => &self.select_unstaked_txo_ada,
            PreparedSelectQuery::UnstakedTxoAsset => &self.select_unstaked_txo_assets,
            PreparedSelectQuery::Txi => &self.select_txi_by_hash,
            PreparedSelectQuery::StakeRegistration => &self.select_stake_registration,
            PreparedSelectQuery::Cip36Registration => &self.select_cip36_registration,
            PreparedSelectQuery::Cip36RegistrationInvalid => {
                &self.select_cip36_registration_invalid
            },
            PreparedSelectQuery::Cip36RegistrationForVoteKey => {
                &self.select_cip36_registration_for_vote_key
            },
            PreparedSelectQuery::Rbac509 => &self.select_rbac509_registration,
            PreparedSelectQuery::Rbac509Invalid => &self.select_rbac509_invalid_registration,
            PreparedSelectQuery::CatalystIdForTxnId => &self.select_catalyst_id_for_txn_id,
            PreparedSelectQuery::CatalystIdForStakeAddress => {
                &self.select_catalyst_id_for_stake_address
            },
            PreparedSelectQuery::CatalystIdForPublicKey => &self.select_catalyst_id_for_public_key,
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
            PreparedDeleteQuery::Txi => &self.delete_txi_by_hash,
            PreparedDeleteQuery::StakeRegistration => &self.delete_stake_registration,
            PreparedDeleteQuery::Cip36Registration => &self.delete_cip36_registration,
            PreparedDeleteQuery::Cip36RegistrationInvalid => {
                &self.delete_cip36_registration_invalid
            },
            PreparedDeleteQuery::Cip36RegistrationForVoteKey => {
                &self.delete_cip36_registration_for_vote_key
            },
            PreparedDeleteQuery::Rbac509 => &self.delete_rbac509_registration,
            PreparedDeleteQuery::Rbac509Invalid => &self.delete_rbac509_invalid_registration,
            PreparedDeleteQuery::CatalystIdForTxnId => &self.delete_catalyst_id_for_txn_id,
            PreparedDeleteQuery::CatalystIdForStakeAddress => {
                &self.delete_catalyst_id_for_stake_address
            },
            PreparedDeleteQuery::CatalystIdForPublicKey => &self.delete_catalyst_id_for_public_key,
        };

        super::session_execute_batch(session, query_map, cfg, query, values).await
    }
}
