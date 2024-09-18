//! Pre-prepare queries for a given session.
//!
//! This improves query execution time.

pub(crate) mod staked_ada;

use std::sync::Arc;

use anyhow::bail;
use crossbeam_skiplist::SkipMap;
use scylla::{
    batch::Batch, prepared_statement::PreparedStatement, serialize::row::SerializeRow,
    transport::iterator::RowIterator, QueryResult, Session,
};
use staked_ada::{
    get_txi_by_txn_hash::GetTxiByTxnHashesQuery,
    get_txo_by_stake_address::GetTxoByStakeAddressQuery, update_txo_spent::UpdateTxoSpentQuery,
};

use super::block::{
    certs::CertInsertQuery, cip36::Cip36InsertQuery, txi::TxiInsertQuery, txo::TxoInsertQuery,
};
use crate::settings::{CassandraEnvVars, CASSANDRA_MIN_BATCH_SIZE};

/// Batches of different sizes, prepared and ready for use.
pub(crate) type SizedBatch = SkipMap<u16, Arc<Batch>>;

/// All Prepared Queries that we know about.
#[allow(clippy::enum_variant_names, dead_code)]
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
}

/// All prepared SELECT query statements.
pub(crate) enum PreparedSelectQuery {
    /// Get TXO by stake address query.
    GetTxoByStakeAddress,
    /// Get TXI by transaction hash query.
    GetTxiByTransactionHash,
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
    pub(crate) async fn new(session: Arc<Session>, cfg: &CassandraEnvVars) -> anyhow::Result<Self> {
        // We initialize like this, so that all errors preparing querys get shown before aborting.
        let txi_insert_queries = TxiInsertQuery::prepare_batch(&session, cfg).await;
        let all_txo_queries = TxoInsertQuery::prepare_batch(&session, cfg).await;
        let stake_registration_insert_queries = CertInsertQuery::prepare_batch(&session, cfg).await;
        let all_cip36_queries = Cip36InsertQuery::prepare_batch(&session, cfg).await;
        let txo_spent_update_queries =
            UpdateTxoSpentQuery::prepare_batch(session.clone(), cfg).await;
        let txo_by_stake_address_query = GetTxoByStakeAddressQuery::prepare(session.clone()).await;
        let txi_by_txn_hash_query = GetTxiByTxnHashesQuery::prepare(session.clone()).await;

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
        session: Arc<Session>, query: &str, cfg: &CassandraEnvVars,
        consistency: scylla::statement::Consistency, idempotent: bool, logged: bool,
    ) -> anyhow::Result<SizedBatch> {
        let sized_batches: SizedBatch = SkipMap::new();

        // First prepare the query. Only needs to be done once, all queries on a batch are the
        // same.
        let prepared = Self::prepare(session, query, consistency, idempotent).await?;

        for batch_size in CASSANDRA_MIN_BATCH_SIZE..=cfg.max_batch_size {
            let mut batch: Batch = Batch::new(if logged {
                scylla::batch::BatchType::Logged
            } else {
                scylla::batch::BatchType::Unlogged
            });
            batch.set_consistency(consistency);
            batch.set_is_idempotent(idempotent);
            for _ in CASSANDRA_MIN_BATCH_SIZE..=batch_size {
                batch.append_statement(prepared.clone());
            }

            sized_batches.insert(batch_size.try_into()?, Arc::new(batch));
        }

        Ok(sized_batches)
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
            PreparedSelectQuery::GetTxoByStakeAddress => &self.txo_by_stake_address_query,
            PreparedSelectQuery::GetTxiByTransactionHash => &self.txi_by_txn_hash_query,
        };

        session
            .execute_iter(prepared_stmt.clone(), params)
            .await
            .map_err(|e| anyhow::anyhow!(e))
    }

    /// Execute a Batch query with the given parameters.
    ///
    /// Values should be a Vec of values which implement `SerializeRow` and they MUST be
    /// the same, and must match the query being executed.
    ///
    /// This will divide the batch into optimal sized chunks and execute them until all
    /// values have been executed or the first error is encountered.
    pub(crate) async fn execute_batch<T: SerializeRow>(
        &self, session: Arc<Session>, cfg: Arc<CassandraEnvVars>, query: PreparedQuery,
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
        };

        let mut results: Vec<QueryResult> = Vec::new();

        let chunks = values.chunks(cfg.max_batch_size.try_into().unwrap_or(1));

        for chunk in chunks {
            let chunk_size: u16 = chunk.len().try_into()?;
            let Some(batch_query) = query_map.get(&chunk_size) else {
                // This should not actually occur.
                bail!("No batch query found for size {}", chunk_size);
            };
            let batch_query_statements = batch_query.value().clone();
            results.push(session.batch(&batch_query_statements, chunk).await?);
        }

        Ok(results)
    }
}
