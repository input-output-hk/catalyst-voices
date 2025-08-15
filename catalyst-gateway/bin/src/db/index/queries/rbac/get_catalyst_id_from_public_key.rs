//! Get Catalyst ID by public key.

use std::sync::{Arc, LazyLock};

use anyhow::{Context, Result};
use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;
use futures::{StreamExt, TryStreamExt};
use moka::policy::EvictionPolicy;
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
        types::{DbCatalystId, DbPublicKey},
    },
    metrics::rbac::reporter::{
        PERSISTENT_PUBLIC_KEYS_CACHE_HIT, PERSISTENT_PUBLIC_KEYS_CACHE_MISS,
        VOLATILE_PUBLIC_KEYS_CACHE_HIT, VOLATILE_PUBLIC_KEYS_CACHE_MISS,
    },
    service::utilities::cache::CacheWrapper,
    settings::Settings,
};

/// A query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_public_key.cql");

/// Function to determine cache entry weighted size.
fn weigher_fn(_: &VerifyingKey, _: &CatalystId) -> u32 {
    1u32
}

/// A persistent cache instance.
static PERSISTENT_CACHE: LazyLock<CacheWrapper<VerifyingKey, CatalystId>> = LazyLock::new(|| {
    CacheWrapper::new(
        "Persistent RBAC Public Keys Cache",
        EvictionPolicy::lru(),
        Settings::rbac_cfg().persistent_pub_keys_cache_size,
        weigher_fn,
    )
});

/// A volatile cache instance.
static VOLATILE_CACHE: LazyLock<CacheWrapper<VerifyingKey, CatalystId>> = LazyLock::new(|| {
    CacheWrapper::new(
        "",
        EvictionPolicy::lru(),
        Settings::rbac_cfg().volatile_pub_keys_cache_size,
        weigher_fn,
    )
});

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
        session: &CassandraSession, public_key: VerifyingKey,
    ) -> Result<Option<CatalystId>> {
        let cache = cache(session.is_persistent());

        let res = cache.get(&public_key);
        update_cache_metrics(session.is_persistent(), res.is_some());
        if let Some(res) = res {
            return Ok(Some(res));
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
    let cache = cache(is_persistent);
    cache.clear_cache();
}

/// Returns an approximate number of entries in the public keys cache.
pub fn public_keys_cache_size(is_persistent: bool) -> u64 {
    let cache = cache(is_persistent);
    cache.entry_count()
}

/// Returns a persistent or a volatile cache instance depending on the parameter value.
fn cache(is_persistent: bool) -> &'static CacheWrapper<VerifyingKey, CatalystId> {
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
            PERSISTENT_PUBLIC_KEYS_CACHE_HIT
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (true, false) => {
            PERSISTENT_PUBLIC_KEYS_CACHE_MISS
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (false, true) => {
            VOLATILE_PUBLIC_KEYS_CACHE_HIT
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (false, false) => {
            VOLATILE_PUBLIC_KEYS_CACHE_MISS
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
    }
}
