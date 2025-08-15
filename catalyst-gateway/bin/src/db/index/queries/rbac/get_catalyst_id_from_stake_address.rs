//! Get Catalyst ID by stake address.

use std::sync::{Arc, LazyLock};

use anyhow::{Context, Result};
use cardano_chain_follower::StakeAddress;
use catalyst_types::catalyst_id::CatalystId;
use futures::{StreamExt, TryStreamExt};
use moka::policy::EvictionPolicy;
use scylla::{
    client::{pager::TypedRowStream, session::Session},
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
        types::{DbCatalystId, DbStakeAddress},
    },
    metrics::rbac::reporter::{
        PERSISTENT_STAKE_ADDRESSES_CACHE_HIT, PERSISTENT_STAKE_ADDRESSES_CACHE_MISS,
        VOLATILE_STAKE_ADDRESSES_CACHE_HIT, VOLATILE_STAKE_ADDRESSES_CACHE_MISS,
    },
    service::utilities::cache::CacheWrapper,
    settings::Settings,
};

/// Get Catalyst ID by stake address query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_stake_address.cql");

/// Function to determine cache entry weighted size.
fn weigher_fn(_: &StakeAddress, _: &CatalystId) -> u32 {
    1u32
}

/// A persistent cache instance.
static PERSISTENT_CACHE: LazyLock<CacheWrapper<StakeAddress, CatalystId>> = LazyLock::new(|| {
    CacheWrapper::new(
        "Persistent RBAC Stake Address Cache",
        EvictionPolicy::lru(),
        Settings::rbac_cfg().persistent_pub_keys_cache_size,
        weigher_fn,
    )
});

/// A volatile cache instance.
static VOLATILE_CACHE: LazyLock<CacheWrapper<StakeAddress, CatalystId>> = LazyLock::new(|| {
    CacheWrapper::new(
        "Volatile RBAC Stake Address Cache",
        EvictionPolicy::lru(),
        Settings::rbac_cfg().volatile_pub_keys_cache_size,
        weigher_fn,
    )
});

/// Get Catalyst ID by stake address query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// Stake address to get the Catalyst ID for.
    pub(crate) stake_address: DbStakeAddress,
}

/// Get Catalyst ID by stake address query.
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct Query {
    /// Catalyst ID for the queries stake address.
    pub catalyst_id: DbCatalystId,
}

impl Query {
    /// Prepares "a get Catalyst ID by stake address" query.
    pub(crate) async fn prepare(session: Arc<Session>) -> Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get Catalyst ID by stake address query"),
            )
    }

    /// Executes a get Catalyst ID by stake address query.
    ///
    /// Use `Query::latest` if you only need the latest value.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> Result<TypedRowStream<Query>> {
        session
            .execute_iter(PreparedSelectQuery::CatalystIdByStakeAddress, params)
            .await?
            .rows_stream::<Query>()
            .map_err(Into::into)
    }

    /// Returns the latest Catalyst ID for the given stake address.
    pub(crate) async fn latest(
        session: &CassandraSession, stake_address: &StakeAddress,
    ) -> Result<Option<CatalystId>> {
        let cache = cache(session.is_persistent());

        let res = cache.get(stake_address);
        update_cache_metrics(session.is_persistent(), res.is_some());
        if let Some(res) = res {
            return Ok(Some(res));
        }

        Self::execute(session, QueryParams {
            stake_address: stake_address.clone().into(),
        })
        .await?
        .map_ok(|q| CatalystId::from(q.catalyst_id))
        .next()
        .await
        .transpose()
        .inspect(|v| {
            if let Some(v) = v {
                cache.insert(stake_address.to_owned(), v.clone());
            }
        })
        .context("Failed to get Catalyst ID by stake address query row")
    }
}

/// Adds the given value to the cache.
pub fn cache_stake_address(
    is_persistent: bool, stake_address: StakeAddress, catalyst_id: CatalystId,
) {
    let cache = cache(is_persistent);
    cache.insert(stake_address, catalyst_id);
}

/// Removes all cached values.
pub fn invalidate_stake_addresses_cache(is_persistent: bool) {
    let cache = cache(is_persistent);
    cache.clear_cache();
}

/// Returns an approximate number of entries in the stake addresses cache.
pub fn stake_addresses_cache_size(is_persistent: bool) -> u64 {
    let cache = cache(is_persistent);
    cache.entry_count()
}

/// Returns a persistent or a volatile cache instance depending on the parameter value.
fn cache(is_persistent: bool) -> &'static CacheWrapper<StakeAddress, CatalystId> {
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
            PERSISTENT_STAKE_ADDRESSES_CACHE_HIT
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (true, false) => {
            PERSISTENT_STAKE_ADDRESSES_CACHE_MISS
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (false, true) => {
            VOLATILE_STAKE_ADDRESSES_CACHE_HIT
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
        (false, false) => {
            VOLATILE_STAKE_ADDRESSES_CACHE_MISS
                .with_label_values(&[&api_host_names, service_id, &network])
                .inc();
        },
    }
}
