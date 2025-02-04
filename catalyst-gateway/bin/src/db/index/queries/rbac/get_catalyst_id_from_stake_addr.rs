//! Get chain root by stake address.
use std::sync::{Arc, LazyLock};

use anyhow::bail;
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
    types::{DbSlot, DbTransactionHash, DbTxnIndex},
};

/// Cached Chain Root By Stake Address.
static CATALYST_ID_BY_STAKE_ADDRESS_CACHE: LazyLock<Cache<StakeAddress, String>> =
    LazyLock::new(|| {
        Cache::builder()
            // Set Eviction Policy to `LRU`
            .eviction_policy(EvictionPolicy::lru())
            // Set the initial capacity
            .initial_capacity(chain_root::LRU_MAX_CAPACITY)
            // Set the maximum number of LRU entries
            .max_capacity(chain_root::LRU_MAX_CAPACITY as u64)
            // Create the cache.
            .build()
    });

/// Get get chain root by stake address query string.
const GET_CHAIN_ROOT: &str = include_str!("../cql/get_rbac_chain_root_for_stake_addr.cql");

/// Get chain root by stake address query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// Stake address to get the chain root for.
    pub(crate) stake_address: Vec<u8>,
}

/// Get chain root by stake address query.
#[derive(DeserializeRow)]
pub(crate) struct Query {
    /// Slot Number the stake address was registered in.
    pub(crate) slot_no: num_bigint::BigInt,
    /// Transaction Offset the stake address was registered in.
    pub(crate) txn: DbTxnIndex,
    /// Chain root for the queries stake address.
    pub(crate) chain_root: DbTransactionHash,
    /// Chain roots slot number
    pub(crate) chain_root_slot: DbSlot,
    /// Chain roots txn index
    pub(crate) chain_root_txn: DbTxnIndex,
}

impl Query {
    /// Prepares a get chain root by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_chain_root_by_stake_address_query = PreparedQueries::prepare(
            session,
            GET_CHAIN_ROOT,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_chain_root_by_stake_address_query {
            error!(error=%error, "Failed to prepare get chain root by stake address query");
        };

        get_chain_root_by_stake_address_query
    }

    /// Executes a get chain root by stake address query.
    /// Don't call directly, use one of the methods instead.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> anyhow::Result<TypedRowStream<Query>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::ChainRootByStakeAddress, params)
            .await?
            .rows_stream::<Query>()?;

        Ok(iter)
    }

    /// Get latest Chain Root for a given stake address, uncached.
    ///
    /// Unless you really know you need an uncached result, use the cached version.
    pub(crate) async fn get_latest_uncached(
        session: &CassandraSession, stake_addr: &StakeAddress,
    ) -> anyhow::Result<Option<String>> {
        let mut result = Self::execute(session, QueryParams {
            stake_address: stake_addr.to_vec(),
        })
        .await?;

        match result.next().await {
            Some(Ok(first_row)) => {
                Ok(Some(ChainRoot::new(
                    first_row.chain_root.into(),
                    first_row.chain_root_slot.into(),
                    first_row.chain_root_txn.into(),
                )))
            },
            Some(Err(err)) => {
                bail!(
                    "Failed to get chain root by stake address query row: {}",
                    err
                );
            },
            None => Ok(None), // Nothing found, but query ran OK.
        }
    }

    /// Get latest chain-root registration for a stake address.
    pub(crate) async fn get_latest(
        session: &CassandraSession, stake_addr: &StakeAddress,
    ) -> anyhow::Result<Option<String>> {
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
pub(crate) fn cache_for_stake_addr(stake: &StakeAddress, catalyst_id: &str) {
    CATALYST_ID_BY_STAKE_ADDRESS_CACHE.insert(stake.clone(), catalyst_id.to_owned())
}
