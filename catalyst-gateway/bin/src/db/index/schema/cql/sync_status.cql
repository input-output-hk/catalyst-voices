-- Most recent completed 
-- Can also be used to convert a known stake key hash back to a full stake address.
CREATE TABLE IF NOT EXISTS sync_status (
    -- Primary Key Data
    end_slot        varint,    -- The slot that has been indexed up-to (inclusive).
    start_slot      varint,    -- The slot the sync block started at (inclusive).
    sync_time       timestamp, -- The time we finished the sync.
    node_id         text,      -- The node that synced this data.

    PRIMARY KEY (end_slot, start_slot, sync_time, node_id)
);
