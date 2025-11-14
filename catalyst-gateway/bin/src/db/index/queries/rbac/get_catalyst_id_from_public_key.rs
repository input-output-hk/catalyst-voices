//! Get Catalyst ID by public key.

use std::sync::Arc;

use anyhow::{Context, Result};
use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;
use futures::{StreamExt, TryStreamExt};
use scylla::{
    DeserializeRow, SerializeRow,
    client::session::Session,
    statement::{Consistency, prepared::PreparedStatement},
};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{PreparedQueries, PreparedSelectQuery},
            session::CassandraSession,
        },
        types::{DbCatalystId, DbPublicKey},
    },
    metrics::caches::rbac::{
        rbac_persistent_public_key_cache_hits_inc, rbac_persistent_public_key_cache_miss_inc,
        rbac_volatile_public_key_cache_hits_inc, rbac_volatile_public_key_cache_miss_inc,
    },
};

/// A query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_public_key.cql");

/// Get Catalyst ID by public key query parameters.
#[derive(SerializeRow)]
struct QueryParams {
    /// A public key.
    public_key: DbPublicKey,
}

/// Get Catalyst ID by public key query.
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct Query {
    /// A Catalyst ID.
    catalyst_id: DbCatalystId,
}

impl Query {
    /// Prepares a "get catalyst ID by public key" query.
    pub(crate) async fn prepare(session: Arc<Session>) -> Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get Catalyst ID by public key query"),
            )
    }

    /// Executes the query and returns a result for the given public key.
    pub(crate) async fn get(
        session: &CassandraSession,
        public_key: VerifyingKey,
    ) -> Result<Option<CatalystId>> {
        let cache = session.caches().rbac_public_key();

        if cache.is_enabled() {
            let entry_opt = cache.get(&public_key);

            let entry_opt = if session.is_persistent() {
                entry_opt
                    .inspect(|_| {
                        rbac_persistent_public_key_cache_hits_inc();
                    })
                    .or_else(|| {
                        rbac_persistent_public_key_cache_miss_inc();
                        None
                    })
            } else {
                entry_opt
                    .inspect(|_| {
                        rbac_volatile_public_key_cache_hits_inc();
                    })
                    .or_else(|| {
                        rbac_volatile_public_key_cache_miss_inc();
                        None
                    })
            };

            if entry_opt.is_some() {
                return Ok(entry_opt);
            }
        }

        session
            .execute_iter(PreparedSelectQuery::CatalystIdByPublicKey, QueryParams {
                public_key: public_key.into(),
            })
            .await?
            .rows_stream::<Query>()?
            .map_ok(|q| CatalystId::from(q.catalyst_id))
            .next()
            .await
            .transpose()
            .inspect(|v| {
                if let Some(v) = v {
                    cache.insert(public_key, v.clone());
                }
            })
            .context("Failed to get Catalyst ID by public key query row")
    }
}

/// Removes all cached values.
pub fn invalidate_public_keys_cache(is_persistent: bool) {
    CassandraSession::get(is_persistent).inspect(|session| {
        session.caches().rbac_public_key().clear_cache();
    });
}
