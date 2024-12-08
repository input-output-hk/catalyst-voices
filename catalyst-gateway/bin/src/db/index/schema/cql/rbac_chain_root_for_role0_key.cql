-- Index of Chain Root For Role0 Key. RBAC 509 registrations. 
CREATE TABLE IF NOT EXISTS rbac_chain_root_for_role0_key (
    -- Primary Key Data
    role0_key           blob,       -- 16 Bytes of Role0 Key. (Role0Kid)
    slot_no             varint,     -- slot number when the key_was_registered. (u64)
    txn                 smallint,   -- Index of the TX which holds the registration data. (i16)
    chain_root          blob,       -- 32 Bytes of Chain Root. (TransactionHash)

    PRIMARY KEY (role0_key, slot_no, txn)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn DESC);
