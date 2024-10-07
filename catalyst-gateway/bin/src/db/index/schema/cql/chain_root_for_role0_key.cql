-- Index of Chain Root For Role0 Key. RBAC 509 registrations. 
CREATE TABLE IF NOT EXISTS chain_root_for_role0_key (
    -- Primary Key Data
    role0_key           blob,       -- 16 Bytes of Role0 Key.
    slot_no             varint,     -- slot number when the key_was_registered.
    txn                 smallint,   -- Index of the TX which holds the registration data.
    chain_root          blob,       -- 32 Bytes of Chain Root.

    PRIMARY KEY (role0_key, slot_no, txn)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn DESC);
