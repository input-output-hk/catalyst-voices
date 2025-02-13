//! Get Catalyst ID by stake address.

use std::sync::{Arc, LazyLock};

use anyhow::{Context, Result};
use cardano_blockchain_types::{Slot, TransactionHash, TxnIndex};
use catalyst_types::id_uri::IdUri;
use futures::StreamExt;
use moka::{policy::EvictionPolicy, sync::Cache};
use scylla::{
    prepared_statement::PreparedStatement, statement::Consistency,
    transport::iterator::TypedRowStream, DeserializeRow, SerializeRow, Session,
};
use tracing::error;

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::{DbCatalystId, DbSlot, DbTransactionHash, DbTxnIndex},
};

/// Cached data.
static CACHE: LazyLock<Cache<DbTransactionHash, Query>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .build()
});

/// A query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_transaction_id.cql");

/// Get Catalyst ID by transaction ID query parameters.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// A transaction hash.
    pub(crate) transaction_id: DbTransactionHash,
}

/// Get Catalyst ID by stake address query.
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct Query {
    /// A Catalyst ID.
    pub catalyst_id: DbCatalystId,
    /// A slot number.
    #[allow(dead_code)]
    pub slot_no: DbSlot,
    /// A transaction index.
    #[allow(dead_code)]
    pub txn_index: DbTxnIndex,
}

impl Query {
    /// Prepares a get catalyst ID by transaction ID query.
    pub(crate) async fn prepare(session: Arc<Session>) -> Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get Catalyst ID by transaction ID query"),
            )
    }

    /// Executes a get Catalyst ID by transaction ID query.
    ///
    /// Don't call directly, use one of the methods instead.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> Result<TypedRowStream<Query>> {
        session
            .execute_iter(PreparedSelectQuery::CatalystIdByTransactionId, params)
            .await?
            .rows_stream::<Query>()
            .map_err(Into::into)
    }

    /// Gets the latest Catalyst ID for the given transaction ID without using cache.
    ///
    /// Unless you really know you need an uncached result, use the cached version.
    pub(crate) async fn get_latest_uncached(
        session: &CassandraSession, transaction_id: DbTransactionHash,
    ) -> Result<Option<Query>> {
        Self::execute(session, QueryParams { transaction_id })
            .await?
            .next()
            .await
            .transpose()
            .context("Failed to get Catalyst ID by transaction ID query row")
    }

    /// Gets the latest Catalyst ID for the given transaction ID.
    pub(crate) async fn get_latest(
        session: &CassandraSession, transaction_id: DbTransactionHash,
    ) -> Result<Option<Query>> {
        match CACHE.get(&transaction_id) {
            Some(v) => Ok(Some(v)),
            None => {
                // Look in DB for the stake registration
                Self::get_latest_uncached(session, transaction_id).await
            },
        }
    }
}

/// Update the cache when a rbac registration is indexed.
pub(crate) fn cache_for_transaction_id(
    transaction_id: TransactionHash, catalyst_id: IdUri, slot_no: Slot, txn_idx: TxnIndex,
) {
    let value = Query {
        catalyst_id: catalyst_id.into(),
        slot_no: slot_no.into(),
        txn_index: txn_idx.into(),
    };
    CACHE.insert(transaction_id.into(), value);
}
