//! Get chain root by role0 key.
use std::sync::{Arc, LazyLock};

use anyhow::bail;
use futures::StreamExt;
use moka::{policy::EvictionPolicy, sync::Cache};
use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowStream, DeserializeRow,
    SerializeRow, Session,
};
use to_vec::ToVec;
use tracing::error;

use crate::{
    db::index::{
        block::rbac509::chain_root::{self, ChainRoot},
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    service::{
        common::auth::rbac::role0_kid::Role0Kid,
        utilities::convert::{big_uint_to_u64, from_saturating},
    },
};

/// Cached Chain Root By Role 0 Kid.
static CHAIN_ROOT_BY_ROLE0_KID_CACHE: LazyLock<Cache<Role0Kid, ChainRoot>> = LazyLock::new(|| {
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

/// Get chain root by role0 key query string.
const GET_ROLE0_KEY_CHAIN_ROOT_CQL: &str =
    include_str!("../cql/get_rbac_chain_root_for_role0_kid.cql");

/// Get chain root by role0 key query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// Role0 key to get the chain root for.
    pub(crate) role0_kid: Vec<u8>,
}

/// Get chain root by role0 key query.
#[derive(DeserializeRow)]
pub(crate) struct Query {
    /// Slot Number the stake address was registered in.
    pub(crate) slot_no: num_bigint::BigInt,
    /// Transaction Offset the stake address was registered in.
    pub(crate) txn: i16,
    /// Chain root for the queries stake address.
    pub(crate) chain_root: Vec<u8>,
    /// Chain roots slot number
    pub(crate) chain_root_slot: num_bigint::BigInt,
    /// Chain roots txn index
    pub(crate) chain_root_txn: i16,
}

impl Query {
    /// Prepares a get chain root by role0 key query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_chain_root_by_role0_key_query = PreparedQueries::prepare(
            session,
            GET_ROLE0_KEY_CHAIN_ROOT_CQL,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_chain_root_by_role0_key_query {
            error!(error=%error, "Failed to prepare get chain root by role0 key query");
        };

        get_chain_root_by_role0_key_query
    }

    /// Executes a get chain root role0 key query.
    ///
    /// Do not use directly, use an exposed method instead.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> anyhow::Result<TypedRowStream<Query>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::ChainRootByRole0Key, params)
            .await?
            .rows_stream::<Query>()?;

        Ok(iter)
    }

    /// Get latest Chain Root for a given stake address, uncached.
    ///
    /// Unless you really know you need an uncached result, use the cached version.
    pub(crate) async fn get_latest_uncached(
        session: &CassandraSession, kid: Role0Kid,
    ) -> anyhow::Result<Option<ChainRoot>> {
        let mut result = Self::execute(
            session,
            QueryParams {
                role0_kid: kid.to_vec(),
            },
        )
        .await?;

        match result.next().await {
            Some(Ok(first_row)) => Ok(Some(ChainRoot::new(
                first_row.chain_root.as_slice().into(),
                big_uint_to_u64(&first_row.chain_root_slot),
                from_saturating(first_row.chain_root_txn),
            ))),
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
        session: &CassandraSession, kid: Role0Kid,
    ) -> anyhow::Result<Option<ChainRoot>> {
        match CHAIN_ROOT_BY_ROLE0_KID_CACHE.get(&kid) {
            Some(chain_root) => Ok(Some(chain_root)),
            None => {
                // Look in DB for the stake registration
                Self::get_latest_uncached(session, kid).await
            },
        }
    }
}

/// Update the cache when a rbac registration is indexed.
pub(crate) fn cache_for_role0_kid(kid: Role0Kid, chain_root: &ChainRoot) {
    CHAIN_ROOT_BY_ROLE0_KID_CACHE.insert(kid.clone(), chain_root.clone())
}
