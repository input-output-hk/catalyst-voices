//! Pre-prepare queries for a given session.
//!
//! This improves query execution time.

pub(crate) mod purge;
pub(crate) mod rbac;
pub(crate) mod registrations;
pub(crate) mod staked_ada;
pub(crate) mod sync_status;

use std::{fmt::Debug, sync::Arc};

use anyhow::bail;
use crossbeam_skiplist::SkipMap;
use rbac::{
    get_chain_root, get_chain_root_from_stake_addr,
    get_registrations::GetRegistrationsByChainRootQuery,
    get_role0_chain_root::Query as GetRole0ChainRootQuery,
};
use registrations::{
    get_all_stakes_and_vote_keys::GetAllStakesAndVoteKeysQuery,
    get_from_stake_addr::GetRegistrationQuery, get_from_stake_hash::GetStakeAddrQuery,
    get_from_vote_key::GetStakeAddrFromVoteKeyQuery, get_invalid::GetInvalidRegistrationQuery,
};
use scylla::{
    batch::Batch, prepared_statement::PreparedStatement, serialize::row::SerializeRow,
    transport::iterator::QueryPager, QueryResult, Session,
};
use staked_ada::{
    get_assets_by_stake_address::GetAssetsByStakeAddressQuery,
    get_txi_by_txn_hash::GetTxiByTxnHashesQuery,
    get_txo_by_stake_address::GetTxoByStakeAddressQuery, update_txo_spent::UpdateTxoSpentQuery,
};
use sync_status::update::SyncStatusInsertQuery;
use tracing::error;

use super::block::{
    certs::CertInsertQuery, cip36::Cip36InsertQuery, rbac509::Rbac509InsertQuery,
    txi::TxiInsertQuery, txo::TxoInsertQuery,
};
use crate::settings::cassandra_db;

/// Batches of different sizes, prepared and ready for use.
pub(crate) type SizedBatch = SkipMap<u16, Arc<Batch>>;

/// All Prepared Queries that we know about.
#[derive(strum_macros::Display)]
#[allow(clippy::enum_variant_names)]
pub(crate) enum PreparedQuery {
    /// TXO Insert query.
    TxoAdaInsertQuery,
    /// TXO Asset Insert query.
    TxoAssetInsertQuery,
    /// Unstaked TXO Insert query.
    UnstakedTxoAdaInsertQuery,
    /// Unstaked TXO Asset Insert query.
    UnstakedTxoAssetInsertQuery,
    /// TXI Insert query.
    TxiInsertQuery,
    /// Stake Registration Insert query.
    StakeRegistrationInsertQuery,
    /// CIP 36 Registration Insert Query.
    Cip36RegistrationInsertQuery,
    /// CIP 36 Registration Error Insert query.
    Cip36RegistrationInsertErrorQuery,
    /// CIP 36 Registration for stake address Insert query.
    Cip36RegistrationForStakeAddrInsertQuery,
    /// TXO spent Update query.
    TxoSpentUpdateQuery,
    /// RBAC 509 Registration Insert query.
    Rbac509InsertQuery,
    /// Chain Root For Transaction ID Insert query.
    ChainRootForTxnIdInsertQuery,
    /// Chain Root For Role0 Key Insert query.
    ChainRootForRole0KeyInsertQuery,
    /// Chain Root For Stake Address Insert query.
    ChainRootForStakeAddressInsertQuery,
}

/// All prepared SELECT query statements (return data).
pub(crate) enum PreparedSelectQuery {
    /// Get TXO by stake address query.
    TxoByStakeAddress,
    /// Get TXI by transaction hash query.
    TxiByTransactionHash,
    /// Get native assets by stake address query.
    AssetsByStakeAddress,
    /// Get Registrations
    RegistrationFromStakeAddr,
    /// Get invalid Registration
    InvalidRegistrationsFromStakeAddr,
    /// Get stake addr from stake hash
    StakeAddrFromStakeHash,
    /// Get stake addr from vote key
    StakeAddrFromVoteKey,
    /// Get chain root by stake address
    ChainRootByStakeAddress,
    /// Get registrations by chain root
    RegistrationsByChainRoot,
    /// Get chain root by role0 key
    ChainRootByRole0Key,
    /// Get chain root by transaction id
    ChainRootByTransactionId,
    /// Get all stake and vote keys for snapshot (`stake_pub_key,vote_key`)
    GetAllStakesAndVoteKeys,
}

/// All prepared UPSERT query statements (inserts/updates a single value of data).
pub(crate) enum PreparedUpsertQuery {
    /// Sync Status Insert
    SyncStatusInsert,
}

/// All prepared queries for a session.
#[allow(clippy::struct_field_names)]
pub(crate) struct PreparedQueries {
    /// TXO Insert query.
    txo_insert_queries: SizedBatch,
    /// TXO Asset Insert query.
    txo_asset_insert_queries: SizedBatch,
    /// Unstaked TXO Insert query.
    unstaked_txo_insert_queries: SizedBatch,
    /// Unstaked TXO Asset Insert query.
    unstaked_txo_asset_insert_queries: SizedBatch,
    /// TXI Insert query.
    txi_insert_queries: SizedBatch,
    /// TXI Insert query.
    stake_registration_insert_queries: SizedBatch,
    /// CIP36 Registrations.
    cip36_registration_insert_queries: SizedBatch,
    /// CIP36 Registration errors.
    cip36_registration_error_insert_queries: SizedBatch,
    /// CIP36 Registration for Stake Address Insert query.
    cip36_registration_for_stake_address_insert_queries: SizedBatch,
    /// Update TXO spent query.
    txo_spent_update_queries: SizedBatch,
    /// Get TXO by stake address query.
    txo_by_stake_address_query: PreparedStatement,
    /// Get TXI by transaction hash.
    txi_by_txn_hash_query: PreparedStatement,
    /// RBAC 509 Registrations.
    rbac509_registration_insert_queries: SizedBatch,
    /// Chain Root for TX ID Insert Query..
    chain_root_for_txn_id_insert_queries: SizedBatch,
    /// Chain Root for Role 0 Key Insert Query..
    chain_root_for_role0_key_insert_queries: SizedBatch,
    /// Chain Root for Stake Address Insert Query..
    chain_root_for_stake_address_insert_queries: SizedBatch,
    /// Get native assets by stake address query.
    native_assets_by_stake_address_query: PreparedStatement,
    /// Get registrations
    registration_from_stake_addr_query: PreparedStatement,
    /// stake addr from stake hash
    stake_addr_from_stake_hash_query: PreparedStatement,
    /// stake addr from vote key
    stake_addr_from_vote_key_query: PreparedStatement,
    /// Get invalid registrations
    invalid_registrations_from_stake_addr_query: PreparedStatement,
    /// Insert Sync Status update.
    sync_status_insert: PreparedStatement,
    /// Get chain root by stake address
    chain_root_by_stake_address_query: PreparedStatement,
    /// Get registrations by chain root
    registrations_by_chain_root_query: PreparedStatement,
    /// Get chain root by role0 key
    chain_root_by_role0_key_query: PreparedStatement,
    /// Get chain root by transaction ID
    chain_root_by_transaction_id_query: PreparedStatement,
    /// Get all stake and vote keys (`stake_key,vote_key`) for snapshot
    get_all_stakes_and_vote_keys_query: PreparedStatement,
}

/// An individual query response that can fail
#[allow(dead_code)]
pub(crate) type FallibleQueryResult = anyhow::Result<QueryResult>;
/// A set of query responses that can fail.
pub(crate) type FallibleQueryResults = anyhow::Result<Vec<QueryResult>>;
/// A set of query responses from tasks that can fail.
pub(crate) type FallibleQueryTasks = Vec<tokio::task::JoinHandle<FallibleQueryResults>>;

impl PreparedQueries {
    /// Create new prepared queries for a given session.
    #[allow(clippy::too_many_lines)]
    pub(crate) async fn new(
        session: Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<Self> {
        // We initialize like this, so that all errors preparing querys get shown before aborting.
        let txi_insert_queries = TxiInsertQuery::prepare_batch(&session, cfg).await;
        let all_txo_queries = TxoInsertQuery::prepare_batch(&session, cfg).await;
        let stake_registration_insert_queries = CertInsertQuery::prepare_batch(&session, cfg).await;
        let all_cip36_queries = Cip36InsertQuery::prepare_batch(&session, cfg).await;
        let txo_spent_update_queries =
            UpdateTxoSpentQuery::prepare_batch(session.clone(), cfg).await;
        let txo_by_stake_address_query = GetTxoByStakeAddressQuery::prepare(session.clone()).await;
        let txi_by_txn_hash_query = GetTxiByTxnHashesQuery::prepare(session.clone()).await;
        let all_rbac_queries = Rbac509InsertQuery::prepare_batch(&session, cfg).await;
        let native_assets_by_stake_address_query =
            GetAssetsByStakeAddressQuery::prepare(session.clone()).await;
        let registration_from_stake_addr_query =
            GetRegistrationQuery::prepare(session.clone()).await;
        let stake_addr_from_stake_hash = GetStakeAddrQuery::prepare(session.clone()).await;
        let stake_addr_from_vote_key = GetStakeAddrFromVoteKeyQuery::prepare(session.clone()).await;
        let invalid_registrations = GetInvalidRegistrationQuery::prepare(session.clone()).await;
        let sync_status_insert = SyncStatusInsertQuery::prepare(session.clone()).await;
        let chain_root_by_stake_address =
            get_chain_root_from_stake_addr::Query::prepare(session.clone()).await;
        let registrations_by_chain_root =
            GetRegistrationsByChainRootQuery::prepare(session.clone()).await;
        let chain_root_by_role0_key = GetRole0ChainRootQuery::prepare(session.clone()).await;
        let chain_root_by_transaction_id = get_chain_root::Query::prepare(session.clone()).await;
        let get_all_stakes_and_vote_keys_query =
            GetAllStakesAndVoteKeysQuery::prepare(session).await;

        let (
            txo_insert_queries,
            unstaked_txo_insert_queries,
            txo_asset_insert_queries,
            unstaked_txo_asset_insert_queries,
        ) = all_txo_queries?;

        let (
            cip36_registration_insert_queries,
            cip36_registration_error_insert_queries,
            cip36_registration_for_stake_address_insert_queries,
        ) = all_cip36_queries?;

        let (
            rbac509_registration_insert_queries,
            chain_root_for_txn_id_insert_queries,
            chain_root_for_role0_key_insert_queries,
            chain_root_for_stake_address_insert_queries,
        ) = all_rbac_queries?;

        Ok(Self {
            txo_insert_queries,
            txo_asset_insert_queries,
            unstaked_txo_insert_queries,
            unstaked_txo_asset_insert_queries,
            txi_insert_queries: txi_insert_queries?,
            stake_registration_insert_queries: stake_registration_insert_queries?,
            cip36_registration_insert_queries,
            cip36_registration_error_insert_queries,
            cip36_registration_for_stake_address_insert_queries,
            txo_spent_update_queries: txo_spent_update_queries?,
            txo_by_stake_address_query: txo_by_stake_address_query?,
            txi_by_txn_hash_query: txi_by_txn_hash_query?,
            rbac509_registration_insert_queries,
            chain_root_for_txn_id_insert_queries,
            chain_root_for_role0_key_insert_queries,
            chain_root_for_stake_address_insert_queries,
            native_assets_by_stake_address_query: native_assets_by_stake_address_query?,
            registration_from_stake_addr_query: registration_from_stake_addr_query?,
            stake_addr_from_stake_hash_query: stake_addr_from_stake_hash?,
            stake_addr_from_vote_key_query: stake_addr_from_vote_key?,
            invalid_registrations_from_stake_addr_query: invalid_registrations?,
            sync_status_insert: sync_status_insert?,
            chain_root_by_stake_address_query: chain_root_by_stake_address?,
            registrations_by_chain_root_query: registrations_by_chain_root?,
            chain_root_by_role0_key_query: chain_root_by_role0_key?,
            chain_root_by_transaction_id_query: chain_root_by_transaction_id?,
            get_all_stakes_and_vote_keys_query: get_all_stakes_and_vote_keys_query?,
        })
    }

    /// Prepares a statement.
    pub(crate) async fn prepare(
        session: Arc<Session>, query: &str, consistency: scylla::statement::Consistency,
        idempotent: bool,
    ) -> anyhow::Result<PreparedStatement> {
        let mut prepared = session.prepare(query).await?;
        prepared.set_consistency(consistency);
        prepared.set_is_idempotent(idempotent);

        Ok(prepared)
    }

    /// Prepares all permutations of the batch from 1 to max.
    /// It is necessary to do this because batches are pre-sized, they can not be dynamic.
    /// Preparing the batches in advance is a very larger performance increase.
    pub(crate) async fn prepare_batch(
        session: Arc<Session>, query: &str, cfg: &cassandra_db::EnvVars,
        consistency: scylla::statement::Consistency, idempotent: bool, logged: bool,
    ) -> anyhow::Result<SizedBatch> {
        let sized_batches: SizedBatch = SkipMap::new();

        // First prepare the query. Only needs to be done once, all queries on a batch are the
        // same.
        let prepared = Self::prepare(session, query, consistency, idempotent).await?;

        for batch_size in cassandra_db::MIN_BATCH_SIZE..=cfg.max_batch_size {
            let mut batch: Batch = Batch::new(if logged {
                scylla::batch::BatchType::Logged
            } else {
                scylla::batch::BatchType::Unlogged
            });
            batch.set_consistency(consistency);
            batch.set_is_idempotent(idempotent);
            for _ in cassandra_db::MIN_BATCH_SIZE..=batch_size {
                batch.append_statement(prepared.clone());
            }

            sized_batches.insert(batch_size.try_into()?, Arc::new(batch));
        }

        Ok(sized_batches)
    }

    /// Executes a single query with the given parameters.
    ///
    /// Returns no data, and an error if the query fails.
    pub(crate) async fn execute_upsert<P>(
        &self, session: Arc<Session>, upsert_query: PreparedUpsertQuery, params: P,
    ) -> anyhow::Result<()>
    where
        P: SerializeRow,
    {
        let prepared_stmt = match upsert_query {
            PreparedUpsertQuery::SyncStatusInsert => &self.sync_status_insert,
        };

        session
            .execute_unpaged(prepared_stmt, params)
            .await
            .map_err(|e| anyhow::anyhow!(e))?;

        Ok(())
    }

    /// Executes a select query with the given parameters.
    ///
    /// Returns an iterator that iterates over all the result pages that the query
    /// returns.
    pub(crate) async fn execute_iter<P>(
        &self, session: Arc<Session>, select_query: PreparedSelectQuery, params: P,
    ) -> anyhow::Result<QueryPager>
    where
        P: SerializeRow,
    {
        let prepared_stmt = match select_query {
            PreparedSelectQuery::TxoByStakeAddress => &self.txo_by_stake_address_query,
            PreparedSelectQuery::TxiByTransactionHash => &self.txi_by_txn_hash_query,
            PreparedSelectQuery::AssetsByStakeAddress => &self.native_assets_by_stake_address_query,
            PreparedSelectQuery::RegistrationFromStakeAddr => {
                &self.registration_from_stake_addr_query
            },
            PreparedSelectQuery::StakeAddrFromStakeHash => &self.stake_addr_from_stake_hash_query,
            PreparedSelectQuery::StakeAddrFromVoteKey => &self.stake_addr_from_vote_key_query,
            PreparedSelectQuery::InvalidRegistrationsFromStakeAddr => {
                &self.invalid_registrations_from_stake_addr_query
            },
            PreparedSelectQuery::ChainRootByStakeAddress => &self.chain_root_by_stake_address_query,
            PreparedSelectQuery::RegistrationsByChainRoot => {
                &self.registrations_by_chain_root_query
            },
            PreparedSelectQuery::ChainRootByRole0Key => &self.chain_root_by_role0_key_query,
            PreparedSelectQuery::ChainRootByTransactionId => {
                &self.chain_root_by_transaction_id_query
            },
            PreparedSelectQuery::GetAllStakesAndVoteKeys => {
                &self.get_all_stakes_and_vote_keys_query
            },
        };
        session_execute_iter(session, prepared_stmt, params).await
    }

    /// Execute a Batch query with the given parameters.
    ///
    /// Values should be a Vec of values which implement `SerializeRow` and they MUST be
    /// the same, and must match the query being executed.
    ///
    /// This will divide the batch into optimal sized chunks and execute them until all
    /// values have been executed or the first error is encountered.
    pub(crate) async fn execute_batch<T: SerializeRow + Debug>(
        &self, session: Arc<Session>, cfg: Arc<cassandra_db::EnvVars>, query: PreparedQuery,
        values: Vec<T>,
    ) -> FallibleQueryResults {
        let query_map = match query {
            PreparedQuery::TxoAdaInsertQuery => &self.txo_insert_queries,
            PreparedQuery::TxoAssetInsertQuery => &self.txo_asset_insert_queries,
            PreparedQuery::UnstakedTxoAdaInsertQuery => &self.unstaked_txo_insert_queries,
            PreparedQuery::UnstakedTxoAssetInsertQuery => &self.unstaked_txo_asset_insert_queries,
            PreparedQuery::TxiInsertQuery => &self.txi_insert_queries,
            PreparedQuery::StakeRegistrationInsertQuery => &self.stake_registration_insert_queries,
            PreparedQuery::Cip36RegistrationInsertQuery => &self.cip36_registration_insert_queries,
            PreparedQuery::Cip36RegistrationInsertErrorQuery => {
                &self.cip36_registration_error_insert_queries
            },
            PreparedQuery::Cip36RegistrationForStakeAddrInsertQuery => {
                &self.cip36_registration_for_stake_address_insert_queries
            },
            PreparedQuery::TxoSpentUpdateQuery => &self.txo_spent_update_queries,
            PreparedQuery::Rbac509InsertQuery => &self.rbac509_registration_insert_queries,
            PreparedQuery::ChainRootForTxnIdInsertQuery => {
                &self.chain_root_for_txn_id_insert_queries
            },
            PreparedQuery::ChainRootForRole0KeyInsertQuery => {
                &self.chain_root_for_role0_key_insert_queries
            },
            PreparedQuery::ChainRootForStakeAddressInsertQuery => {
                &self.chain_root_for_stake_address_insert_queries
            },
        };
        session_execute_batch(session, query_map, cfg, query, values).await
    }
}

/// Execute a Batch query with the given parameters.
///
/// Values should be a Vec of values which implement `SerializeRow` and they MUST be
/// the same, and must match the query being executed.
///
/// This will divide the batch into optimal sized chunks and execute them until all
/// values have been executed or the first error is encountered.
async fn session_execute_batch<T: SerializeRow + Debug, Q: std::fmt::Display>(
    session: Arc<Session>, query_map: &SizedBatch, cfg: Arc<cassandra_db::EnvVars>, query: Q,
    values: Vec<T>,
) -> FallibleQueryResults {
    let mut results: Vec<QueryResult> = Vec::new();

    let chunks = values.chunks(cfg.max_batch_size.try_into().unwrap_or(1));
    let mut query_failed = false;
    let query_str = format!("{query}");

    for chunk in chunks {
        let chunk_size: u16 = chunk.len().try_into()?;
        let Some(batch_query) = query_map.get(&chunk_size) else {
            // This should not actually occur.
            bail!("No batch query found for size {}", chunk_size);
        };
        let batch_query_statements = batch_query.value().clone();
        match session.batch(&batch_query_statements, chunk).await {
            Ok(result) => results.push(result),
            Err(err) => {
                let chunk_str = format!("{chunk:?}");
                error!(error=%err, query=query_str, chunk=chunk_str, "Query Execution Failed");
                query_failed = true;
                // Defer failure until all batches have been processed.
            },
        }
    }

    if query_failed {
        bail!("Query Failed: {query_str}!");
    }

    Ok(results)
}

/// Executes a select query with the given parameters.
///
/// Returns an iterator that iterates over all the result pages that the query
/// returns.
pub(crate) async fn session_execute_iter<P>(
    session: Arc<Session>, prepared_stmt: &PreparedStatement, params: P,
) -> anyhow::Result<QueryPager>
where
    P: SerializeRow,
{
    session
        .execute_iter(prepared_stmt.clone(), params)
        .await
        .map_err(|e| anyhow::anyhow!(e))
}
