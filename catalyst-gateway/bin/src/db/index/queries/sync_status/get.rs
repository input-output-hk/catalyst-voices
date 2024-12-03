//! Get Sync Status query

use tracing::{debug, warn};

use super::update::row::SyncStatusQueryParams;
use crate::{db::index::session::CassandraSession, service::utilities::convert::from_saturating};

/// Get TXI query string.
const GET_SYNC_STATUS: &str = include_str!("../cql/get_sync_status.cql");

/// Clean Sync Status Response
#[derive(PartialEq, Debug)]
pub(crate) struct SyncStatus {
    /// End Slot.
    pub(crate) end_slot: u64,
    /// Start Slot.
    pub(crate) start_slot: u64,
    /// Sync Time.
    pub(crate) sync_time: u64,
    /// Node ID
    pub(crate) node_id: String,
}

/// Convert a big uint to a u64, saturating if its out of range.
fn big_uint_to_u64(value: &num_bigint::BigInt) -> u64 {
    let (sign, digits) = value.to_u64_digits();
    if sign == num_bigint::Sign::Minus || digits.is_empty() {
        return 0;
    }
    if digits.len() > 1 {
        return u64::MAX;
    }
    // 100% safe due to the above checks.
    #[allow(clippy::indexing_slicing)]
    digits[0]
}

/// Merge consecutive sync records, to make processing them easier.
fn merge_consecutive_sync_records(mut synced_chunks: Vec<SyncStatus>) -> Vec<SyncStatus> {
    // Sort the chunks by the starting key, if the ending key overlaps, we will deal with that
    // during the merge.
    synced_chunks.sort_by_key(|rec| rec.start_slot);

    let mut best_sync: Vec<SyncStatus> = vec![];
    let mut current_status: Option<SyncStatus> = None;
    for rec in synced_chunks {
        if let Some(current) = current_status.take() {
            if rec.start_slot >= current.start_slot && rec.end_slot <= current.end_slot {
                // The new record is contained fully within the previous one.
                // We will ignore the new record and use the previous one instead.
                current_status = Some(current);
            } else if rec.start_slot <= current.end_slot + 1 {
                // Either overlaps, or is directly consecutive.
                // But not fully contained within the previous one.
                current_status = Some(SyncStatus {
                    end_slot: rec.end_slot,
                    start_slot: current.start_slot,
                    sync_time: rec.sync_time.max(current.sync_time),
                    node_id: rec.node_id,
                });
            } else {
                // Not consecutive, so store it.
                // And set a new current one.
                best_sync.push(current);
                current_status = Some(rec);
            }
        } else {
            current_status = Some(rec);
        }
    }
    // Could have the final one in current still, so store it
    if let Some(current) = current_status.take() {
        best_sync.push(current);
    }

    best_sync
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
        Ok(result) => result.into_typed::<SyncStatusQueryParams>(),
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
                    end_slot: big_uint_to_u64(&row.end_slot),
                    start_slot: big_uint_to_u64(&row.start_slot),
                    sync_time: from_saturating(row.sync_time.0),
                    node_id: row.node_id,
                });
            },
        }
    }

    merge_consecutive_sync_records(synced_chunks)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    /// This test checks we can properly merge sync status chunks.
    fn test_sync_merge() {
        // Add some test records, out of order.
        // Two mergeable groups
        let synced_chunks: Vec<SyncStatus> = vec![
            SyncStatus {
                end_slot: 200_000,
                start_slot: 112_001,
                sync_time: 1_200_000,
                node_id: "test-node-1".to_string(),
            },
            SyncStatus {
                end_slot: 12000,
                start_slot: 0,
                sync_time: 100_100,
                node_id: "test-node-1".to_string(),
            },
            SyncStatus {
                end_slot: 99000,
                start_slot: 56789,
                sync_time: 200_000,
                node_id: "test-node-2".to_string(),
            },
            SyncStatus {
                end_slot: 112_000,
                start_slot: 100_000,
                sync_time: 1_100_100,
                node_id: "test-node-1".to_string(),
            },
            SyncStatus {
                end_slot: 56789,
                start_slot: 12300,
                sync_time: 200_000,
                node_id: "test-node-2".to_string(),
            },
            SyncStatus {
                end_slot: 12345,
                start_slot: 0,
                sync_time: 100_000,
                node_id: "test-node-1".to_string(),
            },
        ];

        let merged_syncs_status = merge_consecutive_sync_records(synced_chunks);

        // Expected result
        let expected: &[SyncStatus] = &[
            SyncStatus {
                end_slot: 99000,
                start_slot: 0,
                sync_time: 200_000,
                node_id: "test-node-2".to_string(),
            },
            SyncStatus {
                end_slot: 200_000,
                start_slot: 100_000,
                sync_time: 1_200_000,
                node_id: "test-node-1".to_string(),
            },
        ];

        assert_eq!(merged_syncs_status.as_slice(), expected);
    }
}
