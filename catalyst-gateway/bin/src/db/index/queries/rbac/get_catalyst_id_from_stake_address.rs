//! Get Catalyst ID by stake address.

use std::sync::{Arc, LazyLock};

use anyhow::{Context, Result};
use cardano_blockchain_types::{Slot, StakeAddress, TxnIndex};
use catalyst_types::catalyst_id::CatalystId;
use futures::{StreamExt, TryStreamExt};
use moka::{policy::EvictionPolicy, sync::Cache};
use scylla::{
    prepared_statement::PreparedStatement, statement::Consistency,
    transport::iterator::TypedRowStream, DeserializeRow, SerializeRow, Session,
};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{PreparedQueries, PreparedSelectQuery},
            session::CassandraSession,
        },
        types::{DbCatalystId, DbSlot, DbStakeAddress, DbTxnIndex},
    },
    metrics::rbac_cache::reporter::{
        PERSISTENT_STAKE_ADDRESSES_CACHE_HIT, PERSISTENT_STAKE_ADDRESSES_CACHE_MISS,
        VOLATILE_STAKE_ADDRESSES_CACHE_HIT, VOLATILE_STAKE_ADDRESSES_CACHE_MISS,
    },
    settings::Settings,
};

/// Get Catalyst ID by stake address query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_stake_address.cql");

/// A persistent cache instance.
static PERSISTENT_CACHE: LazyLock<Cache<StakeAddress, QueryResult>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .max_capacity(Settings::rbac_cfg().persistent_pub_keys_cache_size)
        .build()
});

/// A volatile cache instance.
static VOLATILE_CACHE: LazyLock<Cache<StakeAddress, QueryResult>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .max_capacity(Settings::rbac_cfg().volatile_pub_keys_cache_size)
        .build()
});

/// A result of query execution.
#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct QueryResult {
    /// A Catalyst ID.
    pub catalyst_id: CatalystId,
    /// A slot number.
    pub slot_no: Slot,
    /// A transaction index.
    pub txn_index: TxnIndex,
}

/// Get Catalyst ID by stake address query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// Stake address to get the Catalyst ID for.
    pub(crate) stake_address: DbStakeAddress,
}

/// Get Catalyst ID by stake address query.
#[allow(dead_code)]
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct Query {
    /// Catalyst ID for the queries stake address.
    pub catalyst_id: DbCatalystId,
    /// A slot number.
    pub slot_no: DbSlot,
    /// A transaction index.
    pub txn_index: DbTxnIndex,
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
        session: &CassandraSession, stake_address: StakeAddress,
    ) -> Result<Option<QueryResult>> {
        let cache = cache(session.is_persistent());

        let res = cache.get(&stake_address);
        update_cache_metrics(session.is_persistent(), res.is_some());
        if let Some(res) = res {
            return Ok(Some(res));
        }

        Self::execute(session, QueryParams {
            stake_address: stake_address.clone().into(),
        })
        .await?
        .map_ok(Into::<QueryResult>::into)
        .next()
        .await
        .transpose()
        .inspect(|v| {
            if let Some(v) = v {
                cache.insert(stake_address, v.clone());
            }
        })
        .context("Failed to get Catalyst ID by stake address query row")
    }
}

impl From<Query> for QueryResult {
    fn from(v: Query) -> Self {
        Self {
            catalyst_id: v.catalyst_id.into(),
            slot_no: v.slot_no.into(),
            txn_index: v.txn_index.into(),
        }
    }
}

/// Adds the given value to the cache.
#[allow(dead_code)]
pub fn cache_stake_address(
    is_persistent: bool, stake_address: StakeAddress, catalyst_id: CatalystId, slot_no: Slot,
    txn_index: TxnIndex,
) {
    let cache = cache(is_persistent);
    cache.insert(stake_address, QueryResult {
        catalyst_id,
        slot_no,
        txn_index,
    });
}

/// Removes all cached values.
#[allow(dead_code)]
pub fn invalidate_cache(is_persistent: bool) {
    let cache = cache(is_persistent);
    cache.invalidate_all();
}

/// Returns an approximate number of entries in the stake addresses cache.
pub fn stake_addresses_cache_size(is_persistent: bool) -> u64 {
    let cache = cache(is_persistent);
    cache.entry_count()
}

/// Returns a persistent or a volatile cache instance depending on the parameter value.
fn cache(is_persistent: bool) -> &'static Cache<StakeAddress, QueryResult> {
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

    match (is_persistent, is_found) {
        (true, true) => {
            PERSISTENT_STAKE_ADDRESSES_CACHE_HIT
                .with_label_values(&[&api_host_names, service_id])
                .inc();
        },
        (true, false) => {
            PERSISTENT_STAKE_ADDRESSES_CACHE_MISS
                .with_label_values(&[&api_host_names, service_id])
                .inc();
        },
        (false, true) => {
            VOLATILE_STAKE_ADDRESSES_CACHE_HIT
                .with_label_values(&[&api_host_names, service_id])
                .inc();
        },
        (false, false) => {
            VOLATILE_STAKE_ADDRESSES_CACHE_MISS
                .with_label_values(&[&api_host_names, service_id])
                .inc();
        },
    }
}
