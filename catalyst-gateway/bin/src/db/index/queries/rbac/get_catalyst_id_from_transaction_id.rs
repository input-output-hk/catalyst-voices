//! Get Catalyst ID by transaction ID.

use std::sync::Arc;

use anyhow::{Context, Result};
use cardano_chain_follower::hashes::TransactionId;
use catalyst_types::catalyst_id::CatalystId;
use futures::{StreamExt, TryStreamExt};
use scylla::{
    client::session::Session,
    statement::{prepared::PreparedStatement, Consistency},
    DeserializeRow, SerializeRow,
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
    metrics::caches::rbac::{
        rbac_persistent_transaction_id_cache_hits_inc,
        rbac_persistent_transaction_id_cache_miss_inc, rbac_volatile_transaction_id_cache_hits_inc,
        rbac_volatile_transaction_id_cache_miss_inc,
    },
};

/// A query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_transaction_id.cql");

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
        session: &CassandraSession,
        txn_id: TransactionId,
    ) -> Result<Option<CatalystId>> {
        let cache = session.caches().rbac_transaction_id();

        if cache.is_enabled() {
            let entry_opt = cache.get(&txn_id);
            let entry_opt = if session.is_persistent() {
                entry_opt
                    .inspect(|_| rbac_persistent_transaction_id_cache_hits_inc())
                    .or_else(|| {
                        rbac_persistent_transaction_id_cache_miss_inc();
                        None
                    })
            } else {
                entry_opt
                    .inspect(|_| rbac_volatile_transaction_id_cache_hits_inc())
                    .or_else(|| {
                        rbac_volatile_transaction_id_cache_miss_inc();
                        None
                    })
            };
            if entry_opt.is_some() {
                return Ok(entry_opt);
            }
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
            .map_ok(|q| CatalystId::from(q.catalyst_id))
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

/// Removes all cached values.
pub fn invalidate_transactions_ids_cache(is_persistent: bool) {
    CassandraSession::get(is_persistent).inspect(|session| {
        session.caches().rbac_transaction_id().clear_cache();
    });
}
