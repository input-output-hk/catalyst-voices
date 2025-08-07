//! Get RBAC registrations by Catalyst ID.

use std::{collections::HashSet, sync::Arc};

use scylla::{
    client::{pager::TypedRowStream, session::Session},
    statement::{prepared::PreparedStatement, Consistency},
    DeserializeRow, SerializeRow,
};
use tracing::error;

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::{DbCatalystId, DbSlot, DbStakeAddress, DbTransactionId, DbTxnIndex},
};

/// Get registrations by Catalyst ID query.
const QUERY: &str = include_str!("../cql/get_rbac_registrations_catalyst_id.cql");

/// Get registrations by Catalyst ID query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// A Catalyst ID.
    pub catalyst_id: DbCatalystId,
}

/// Get registrations by Catalyst ID query.
#[derive(DeserializeRow, Clone)]
pub(crate) struct Query {
    /// Registration transaction id.
    #[allow(dead_code)]
    pub txn_id: DbTransactionId,
    /// A block slot number.
    pub slot_no: DbSlot,
    /// A transaction index.
    pub txn_index: DbTxnIndex,
    /// A previous  transaction id.
    #[allow(dead_code)]
    pub prv_txn_id: Option<DbTransactionId>,
    /// A set of removed stake addresses.
    pub removed_stake_addresses: HashSet<DbStakeAddress>,
}

impl Query {
    /// Prepares a query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get RBAC registrations by Catalyst ID query"),
            )
    }

    /// Executes a get registrations by Catalyst ID query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> anyhow::Result<TypedRowStream<Query>> {
        session
            .execute_iter(PreparedSelectQuery::RbacRegistrationsByCatalystId, params)
            .await?
            .rows_stream::<Query>()
            .map_err(Into::into)
    }
}
