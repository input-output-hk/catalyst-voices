//! Get Catalyst ID by transaction ID.

use std::sync::{Arc, LazyLock};

use anyhow::{Context, Result};
use cardano_blockchain_types::TransactionId;
use catalyst_types::catalyst_id::CatalystId;
use futures::{StreamExt, TryStreamExt};
use moka::{policy::EvictionPolicy, sync::Cache};
use scylla::{
    prepared_statement::PreparedStatement, statement::Consistency, DeserializeRow, SerializeRow,
    Session,
};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{PreparedQueries, PreparedSelectQuery},
            session::CassandraSession,
        },
        types::{DbCatalystId, DbTransactionId},
    },
    metrics::rbac_cache::reporter::{
        PERSISTENT_TRANSACTION_IDS_CACHE_HIT, PERSISTENT_TRANSACTION_IDS_CACHE_MISS,
        VOLATILE_TRANSACTION_IDS_CACHE_HIT, VOLATILE_TRANSACTION_IDS_CACHE_MISS,
    },
    settings::Settings,
};

/// A query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_transaction_id.cql");

/// A persistent cache instance.
static PERSISTENT_CACHE: LazyLock<Cache<TransactionId, QueryResult>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .max_capacity(Settings::rbac_cfg().persistent_pub_keys_cache_size)
        .build()
});

/// A volatile cache instance.
static VOLATILE_CACHE: LazyLock<Cache<TransactionId, QueryResult>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .max_capacity(Settings::rbac_cfg().volatile_pub_keys_cache_size)
        .build()
});

/// A result of query execution.
#[derive(Debug, Clone)]
pub struct QueryResult {
    /// A Catalyst ID.
    pub catalyst_id: CatalystId,
}

/// Get Catalyst ID by transaction ID query parameters.
#[derive(SerializeRow)]
struct QueryParams {
    /// A transaction hash.
    txn_id: DbTransactionId,
}

/// Get Catalyst ID by transaction ID query.
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct Query {
    /// A Catalyst ID.
    pub catalyst_id: DbCatalystId,
}

impl Query {
    /// Prepares a "get catalyst ID by transaction ID" query.
    pub(crate) async fn prepare(session: Arc<Session>) -> Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get Catalyst ID by transaction ID query"),
            )
    }

    /// Executes the query and returns a result for the given transaction ID.
    pub(crate) async fn get(
        session: &CassandraSession, txn_id: TransactionId,
    ) -> Result<Option<QueryResult>> {
        let cache = cache(session.is_persistent());

        let res = cache.get(&txn_id);
        update_cache_metrics(session.is_persistent(), res.is_some());
        if let Some(res) = res {
            return Ok(Some(res));
        }

        session
            .execute_iter(
                PreparedSelectQuery::CatalystIdByTransactionId,
                QueryParams {
                    txn_id: txn_id.into(),
                },
            )
            .await?
            .rows_stream::<Query>()?
            .map_ok(Into::<QueryResult>::into)
            .next()
            .await
            .transpose()
            .inspect(|v| {
                if let Some(v) = v {
                    cache.insert(txn_id, v.clone());
                }
            })
            .context("Failed to get Catalyst ID by transaction ID query row")
    }
}

impl From<Query> for QueryResult {
    fn from(v: Query) -> Self {
        Self {
            catalyst_id: v.catalyst_id.into(),
        }
    }
}

/// Removes all cached values.
pub fn invalidate_transactions_ids_cache(is_persistent: bool) {
    let cache = cache(is_persistent);
    cache.invalidate_all();
}

/// Returns an approximate number of entries in the transaction IDs cache.
pub fn transaction_ids_cache_size(is_persistent: bool) -> u64 {
    let cache = cache(is_persistent);
    cache.entry_count()
}

/// Returns a persistent or a volatile cache instance depending on the parameter value.
fn cache(is_persistent: bool) -> &'static Cache<TransactionId, QueryResult> {
    if is_persistent {
        &PERSISTENT_CACHE
    } else {
        &VOLATILE_CACHE
    }
}

/// Updates metrics of the cache.
fn update_cache_metrics(is_persistent: bool, is_found: bool) {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    match (is_persistent, is_found) {
        (true, true) => {
            PERSISTENT_TRANSACTION_IDS_CACHE_HIT
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (true, false) => {
            PERSISTENT_TRANSACTION_IDS_CACHE_MISS
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (false, true) => {
            VOLATILE_TRANSACTION_IDS_CACHE_HIT
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (false, false) => {
            VOLATILE_TRANSACTION_IDS_CACHE_MISS
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
    }
}
