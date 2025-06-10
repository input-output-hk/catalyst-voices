//! Get Catalyst ID by public key.

use std::sync::{Arc, LazyLock};

use anyhow::{Context, Result};
use cardano_blockchain_types::Slot;
use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;
use futures::{StreamExt, TryStreamExt};
use moka::{policy::EvictionPolicy, sync::Cache};
use scylla::{
    prepared_statement::PreparedStatement, statement::Consistency, DeserializeRow, SerializeRow,
    Session,
};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{PreparedQueries, PreparedSelectQuery},
            session::CassandraSession,
        },
        types::{DbCatalystId, DbPublicKey, DbSlot},
    },
    settings::Settings,
};

static PERSISTENT_CACHE: LazyLock<Cache<VerifyingKey, QueryResult>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .max_capacity(Settings::rbac_cfg().persistent_pub_keys_cache_size)
        .build()
});

static VOLATILE_CACHE: LazyLock<Cache<VerifyingKey, QueryResult>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .max_capacity(Settings::rbac_cfg().volatile_pub_keys_cache_size)
        .build()
});

/// A query string.
const QUERY: &str = include_str!("../cql/get_catalyst_id_for_public_key.cql");

/// A result of query execution.
#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct QueryResult {
    /// A Catalyst ID.
    pub catalyst_id: CatalystId,
    /// A slot number.
    pub slot_no: Slot,
}

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
    pub catalyst_id: DbCatalystId,
    /// A slot number.
    pub slot_no: DbSlot,
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
    ) -> Result<Option<QueryResult>> {
        let cache = if session.is_persistent() {
            &PERSISTENT_CACHE
        } else {
            &VOLATILE_CACHE
        };

        if let Some(res) = cache.get(&public_key) {
            return Ok(Some(res));
        }

        session
            .execute_iter(PreparedSelectQuery::CatalystIdByPublicKey, QueryParams {
                public_key: public_key.into(),
            })
            .await?
            .rows_stream::<Query>()?
            .map_ok(Into::<QueryResult>::into)
            .next()
            .await
            .transpose()
            .inspect(|v| {
                if let Some(v) = v {
                    cache.insert(public_key, v.clone())
                }
            })
            .context("Failed to get Catalyst ID by transaction ID query row")
    }
}

impl From<Query> for QueryResult {
    fn from(v: Query) -> Self {
        Self {
            catalyst_id: v.catalyst_id.into(),
            slot_no: v.slot_no.into(),
        }
    }
}
