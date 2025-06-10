//! Get Catalyst ID by public key.

use std::sync::Arc;

use anyhow::{Context, Result};
use ed25519_dalek::VerifyingKey;
use futures::StreamExt;
use scylla::{
    prepared_statement::PreparedStatement, statement::Consistency, DeserializeRow, SerializeRow,
    Session,
};
use tracing::error;

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::{DbCatalystId, DbPublicKey, DbSlot},
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
    ) -> Result<Option<Query>> {
        session
            .execute_iter(PreparedSelectQuery::CatalystIdByPublicKey, QueryParams {
                public_key: public_key.into(),
            })
            .await?
            .rows_stream::<Query>()?
            .next()
            .await
            .transpose()
            .context("Failed to get Catalyst ID by public key query row")
    }
}
