//! Get Catalyst ID by stake address.

use std::sync::{Arc, LazyLock};

use anyhow::{Context, Result};
use cardano_blockchain_types::{Slot, StakeAddress, TxnIndex};
use catalyst_types::catalyst_id::CatalystId;
use futures::StreamExt;
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
    ) -> Result<Option<Query>> {
        Self::execute(session, QueryParams {
            stake_address: stake_address.into(),
        })
        .await?
        .next()
        .await
        .transpose()
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

/// Returns a persistent or a volatile cache instance depending on the parameter value.
fn cache(is_persistent: bool) -> &'static Cache<StakeAddress, QueryResult> {
    if is_persistent {
        &PERSISTENT_CACHE
    } else {
        &VOLATILE_CACHE
    }
}
