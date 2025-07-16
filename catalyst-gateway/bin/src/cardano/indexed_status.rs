//! An `IndexedStatus` structure.

use cardano_blockchain_types::Slot;

use crate::db::index::queries::sync_status::get::SyncStatus;

/// A helper indexed status structure.
///
/// Its a collection of sorted ranges of indexed chunks of blocks.
/// The first value is always a start of the range and second value is the end of the
/// range.
/// E.g.:
/// [(`block_0`, `block_100`), (`block_150`, `block_TIP`)],
/// NOT indexed chunk is from `block_100` to `block_150`, the rest of the data is
/// indexed already
#[derive(Debug, Clone, Default)]
pub(crate) struct IndexedStatus(Vec<(Slot, Slot)>);

impl IntoIterator for IndexedStatus {
    type IntoIter = <Vec<(Slot, Slot)> as IntoIterator>::IntoIter;
    type Item = (Slot, Slot);

    fn into_iter(self) -> Self::IntoIter {
        self.0.into_iter()
    }
}

impl<'a> IntoIterator for &'a IndexedStatus {
    type IntoIter = <&'a Vec<(Slot, Slot)> as IntoIterator>::IntoIter;
    type Item = &'a (Slot, Slot);

    fn into_iter(self) -> Self::IntoIter {
        self.0.iter()
    }
}

impl From<Vec<SyncStatus>> for IndexedStatus {
    fn from(value: Vec<SyncStatus>) -> Self {
        Self(merge_consecutive_indexed_chunks(
            value
                .into_iter()
                .map(|v| (v.start_slot, v.end_slot))
                .collect(),
        ))
    }
}

/// Merge consecutive indexed chunks, to make processing them easier.
fn merge_consecutive_indexed_chunks(mut synced_chunks: Vec<(Slot, Slot)>) -> Vec<(Slot, Slot)> {
    // Sort the chunks by the starting key, if the ending key overlaps, we will deal with that
    // during the merge.
    synced_chunks.sort_by_key(|rec| rec.0);

    let mut best_sync: Vec<(Slot, Slot)> = vec![];
    let mut current_status: Option<(Slot, Slot)> = None;
    for rec in synced_chunks {
        if let Some(current) = current_status.take() {
            if rec.0 >= current.0 && rec.1 <= current.1 {
                // The new record is contained fully within the previous one.
                // We will ignore the new record and use the previous one instead.
                current_status = Some(current);
            } else if rec.0 <= u64::from(current.1).saturating_add(1).into() {
                // Either overlaps, or is directly consecutive.
                // But not fully contained within the previous one.
                current_status = Some((current.0, rec.1));
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_merge_consecutive_indexed_chunks() {
        // Add some test records, out of order.
        // Two mergeable groups
        let synced_chunks: Vec<(Slot, Slot)> = vec![
            (112_001.into(), 200_000.into()),
            (0.into(), 12000.into()),
            (56789.into(), 99000.into()),
            (100_000.into(), 112_000.into()),
            (12300.into(), 56789.into()),
            (0.into(), 12345.into()),
        ];

        let merged_syncs_status = merge_consecutive_indexed_chunks(synced_chunks);

        // Expected result
        let expected: &[(Slot, Slot)] =
            &[(0.into(), 99000.into()), (100_000.into(), 200_000.into())];

        assert_eq!(merged_syncs_status.as_slice(), expected);
    }
}
