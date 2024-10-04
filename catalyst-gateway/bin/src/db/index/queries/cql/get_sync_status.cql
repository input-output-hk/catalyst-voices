-- Get all the sync status records.
SELECT
    end_slot,
    start_slot,
    sync_time,
    node_id
FROM sync_status;
