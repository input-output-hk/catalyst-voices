//! Read and write the synchronisation status.

use std::{sync::Arc, time::SystemTime};

use row::SyncStatusQueryParams;
use scylla::{frame::value::CqlTimestamp, prepared_statement::PreparedStatement, Session};
use tokio::task;
use tracing::{error, warn};

use crate::{
    db::index::{
        queries::{PreparedQueries, PreparedUpsertQuery},
        session::CassandraSession,
    },
    service::utilities::convert::from_saturating,
    settings::Settings,
};

/// Insert Sync Status query string.
const INSERT_SYNC_STATUS_QUERY: &str = include_str!("../cql/insert_sync_status.cql");

/// Sync Status Row Record Module
#[allow(clippy::expect_used)]
pub(super) mod row {
    use scylla::{frame::value::CqlTimestamp, FromRow, SerializeRow};

    /// Sync Status Record Row (used for both Insert and Query response)
    #[derive(SerializeRow, FromRow, Debug)]
    pub(crate) struct SyncStatusQueryParams {
        /// End Slot.
        pub(crate) end_slot: num_bigint::BigInt,
        /// Start Slot.
        pub(crate) start_slot: num_bigint::BigInt,
        /// Sync Time.
        pub(crate) sync_time: CqlTimestamp,
        /// Node ID
        pub(crate) node_id: String,
    }
}

impl SyncStatusQueryParams {
    /// Create a new instance of [`SyncStatusQueryParams`]
    pub(crate) fn new(end_slot: u64, start_slot: u64) -> Self {
        let sync_time = match SystemTime::now().duration_since(SystemTime::UNIX_EPOCH) {
            Ok(now) => now.as_millis(),
            Err(_) => 0, // Shouldn't actually happen.
        };

        Self {
            end_slot: end_slot.into(),
            start_slot: start_slot.into(),
            sync_time: CqlTimestamp(from_saturating(sync_time)),
            node_id: Settings::service_id().to_owned(),
        }
    }
}

/// Sync Status Insert query.
pub(crate) struct SyncStatusInsertQuery;

impl SyncStatusInsertQuery {
    /// Prepares a Sync Status Insert query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let sync_status_insert_query = PreparedQueries::prepare(
            session,
            INSERT_SYNC_STATUS_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = sync_status_insert_query {
            error!(error=%error, "Failed to prepare get Sync Status Insert query.");
        };

        sync_status_insert_query
    }

    /// Executes a sync status insert query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: SyncStatusQueryParams,
    ) -> anyhow::Result<()> {
        session
            .execute_upsert(PreparedUpsertQuery::SyncStatusInsert, params)
            .await
    }
}

/// Update the sync status of the immutable database.
///
/// Note: There is no need to update the sync status of the volatile database.
///
/// Regarding failures:
/// Failures of this function to record status, fail safely.
/// This data is only used to recover sync
/// There fore this function is both fire and forget, and returns no status.
pub(crate) fn update_sync_status(end_slot: u64, start_slot: u64) {
    task::spawn(async move {
        let Some(session) = CassandraSession::get(true) else {
            warn!(
                start_slot = start_slot,
                end_slot = end_slot,
                "Failed to get Cassandra Session, trying to record indexing status"
            );
            return;
        };

        if let Err(err) = SyncStatusInsertQuery::execute(
            &session,
            SyncStatusQueryParams::new(end_slot, start_slot),
        )
        .await
        {
            warn!(
                error=%err,
                start_slot = start_slot,
                end_slot = end_slot,
                "Failed to store Sync Status"
            );
        };
    });
}
