//! Get Sync Status query

use cardano_blockchain_types::Slot;
use futures::stream::StreamExt;
use tracing::{debug, warn};

use super::update::row::SyncStatusQueryParams;
use crate::{db::index::session::CassandraSession, service::utilities::convert::from_saturating};

/// Get TXI query string.
const GET_SYNC_STATUS: &str = include_str!("../cql/get_sync_status.cql");

/// Clean Sync Status Response
#[derive(PartialEq, Debug)]
pub(crate) struct SyncStatus {
    /// End Slot.
    pub(crate) end_slot: Slot,
    /// Start Slot.
    pub(crate) start_slot: Slot,
    /// Sync Time.
    pub(crate) sync_time: u64,
    /// Node ID
    pub(crate) node_id: String,
}

/// Get the sync status.
///
/// Note: This only happens once when a node starts.  So there is no need to prepare it.
/// It is also only ever run on the persistent database.
///
/// Regarding failures:
/// Failures of this function will simply cause the node to re-sync which is non fatal.
pub(crate) async fn get_sync_status() -> Vec<SyncStatus> {
    let mut synced_chunks: Vec<SyncStatus> = vec![];

    let Some(session) = CassandraSession::get(true) else {
        warn!("Failed to get Cassandra Session, trying to get current indexing status");
        return synced_chunks;
    };

    // Get the raw underlying session, so we can do an unprepared simple query.
    let session = session.get_raw_session();

    let mut results = match session.query_iter(GET_SYNC_STATUS, ()).await {
        Ok(result) => {
            match result.rows_stream::<SyncStatusQueryParams>() {
                Ok(result) => result,
                Err(err) => {
                    warn!(error=%err, "Failed to get sync status results from query.");
                    return synced_chunks;
                },
            }
        },
        Err(err) => {
            warn!(error=%err, "Failed to get sync status results from query.");
            return synced_chunks;
        },
    };

    // Get all the sync records, and de-cassandra-ize the values
    while let Some(next_row) = results.next().await {
        match next_row {
            Err(err) => warn!(error=%err, "Failed to deserialize sync status results from query."),
            Ok(row) => {
                debug!("Sync Status:  {:?}", row);
                synced_chunks.push(SyncStatus {
                    end_slot: row.end_slot.into(),
                    start_slot: row.start_slot.into(),
                    sync_time: from_saturating(row.sync_time.0),
                    node_id: row.node_id,
                });
            },
        }
    }

    synced_chunks
}
