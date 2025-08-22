//! Get Catalyst ID by stake address.

use std::sync::Arc;

use anyhow::{Context, Result};
use cardano_chain_follower::StakeAddress;
use catalyst_types::catalyst_id::CatalystId;
use futures::{StreamExt, TryStreamExt};
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
    metrics::rbac::{
        rbac_persistent_stake_address_cache_hits_inc, rbac_persistent_stake_address_cache_miss_inc,
        rbac_volatile_stake_address_cache_hits_inc, rbac_volatile_stake_address_cache_miss_inc,
    },
};

/// Get Catalyst ID by stake address query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_stake_address.cql");

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
        let cache = session.caches().rbac_stake_address();

        if cache.is_enabled() {
            let entry_opt = cache.get(stake_address);

            let entry_opt = if session.is_persistent() {
                entry_opt
                    .inspect(|_| {
                        rbac_persistent_stake_address_cache_hits_inc();
                    })
                    .or_else(|| {
                        rbac_persistent_stake_address_cache_miss_inc();
                        None
                    })
            } else {
                entry_opt
                    .inspect(|_| {
                        rbac_volatile_stake_address_cache_hits_inc();
                    })
                    .or_else(|| {
                        rbac_volatile_stake_address_cache_miss_inc();
                        None
                    })
            };

            if entry_opt.is_some() {
                return Ok(entry_opt);
            }
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
    CassandraSession::get(is_persistent).inspect(|session| {
        session
            .caches()
            .rbac_stake_address()
            .insert(stake_address, catalyst_id);
    });
}

/// Removes all cached values.
pub fn invalidate_stake_addresses_cache(is_persistent: bool) {
    CassandraSession::get(is_persistent).inspect(|session| {
        session.caches().rbac_stake_address().clear_cache();
    });
}
