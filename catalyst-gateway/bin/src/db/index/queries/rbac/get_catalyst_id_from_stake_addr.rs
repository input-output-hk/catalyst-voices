//! Get Catalyst ID by stake address.

use std::sync::{Arc, LazyLock};

use anyhow::Context;
use futures::StreamExt;
use moka::{policy::EvictionPolicy, sync::Cache};
use pallas::ledger::addresses::StakeAddress;
use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, DeserializeRow,
    SerializeRow, Session,
};
use tracing::error;

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::{DbCatalystId, DbSlot, DbTxnIndex},
};

/// Cached Chain Root By Stake Address.
static CATALYST_ID_BY_STAKE_ADDRESS_CACHE: LazyLock<Cache<StakeAddress, Query>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Create the cache.
            .build()
    });

/// Get Catalyst ID by stake address query string.
const QUERY: &str = include_str!("../cql/get_rbac_chain_root_for_stake_addr.cql");

/// Get Catalyst ID by stake address query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// Stake address to get the Catalyst ID for.
    pub(crate) stake_address: Vec<u8>,
}

/// Get Catalyst ID by stake address query.
#[derive(Debug, Clone, DeserializeRow)]
pub(crate) struct Query {
    /// Slot Number the stake address was registered in.
    pub(crate) slot_no: DbSlot,
    /// Transaction Offset the stake address was registered in.
    pub(crate) txn: DbTxnIndex,
    /// Catalyst ID for the queries stake address.
    pub(crate) catalyst_id: DbCatalystId,
}

impl Query {
    /// Prepares a get Catalyst ID by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, scylla::statement::Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get Catalyst ID by stake address query"),
            )
    }

    /// Executes a get Catalyst ID by stake address query.
    /// Don't call directly, use one of the methods instead.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> anyhow::Result<TypedRowStream<Query>> {
        session
            .execute_iter(PreparedSelectQuery::CatalystIdByStakeAddress, params)
            .await?
            .rows_stream::<Query>()
            .map_err(Into::into)
    }

    /// Get latest Catalyst ID for a given stake address, uncached.
    ///
    /// Unless you really know you need an uncached result, use the cached version.
    pub(crate) async fn get_latest_uncached(
        session: &CassandraSession, stake_addr: &StakeAddress,
    ) -> anyhow::Result<Option<Query>> {
        Self::execute(session, QueryParams {
            stake_address: stake_addr.to_vec(),
        })
        .await?
        .next()
        .await
        .transpose()
        .context("Failed to get Catalyst ID by stake address query row")
    }

    /// Get latest chain-root registration for a stake address.
    pub(crate) async fn get_latest(
        session: &CassandraSession, stake_addr: &StakeAddress,
    ) -> anyhow::Result<Option<Query>> {
        match CATALYST_ID_BY_STAKE_ADDRESS_CACHE.get(stake_addr) {
            Some(chain_root) => Ok(Some(chain_root)),
            None => {
                // Look in DB for the stake registration
                Self::get_latest_uncached(session, stake_addr).await
            },
        }
    }
}

/// Update the cache when a rbac registration is indexed.
pub(crate) fn cache_for_stake_addr(
    stake: &StakeAddress, slot_no: DbSlot, txn: DbTxnIndex, catalyst_id: DbCatalystId,
) {
    let value = Query {
        slot_no,
        txn,
        catalyst_id,
    };
    CATALYST_ID_BY_STAKE_ADDRESS_CACHE.insert(stake.clone(), value)
}
