-- Insert an update to the synchronisation status table
INSERT INTO sync_status (
    end_slot,
    start_slot,
    sync_time,
    node_id
) VALUES (
    :end_slot, 
    :start_slot, 
    :sync_time,
    :node_id
);
