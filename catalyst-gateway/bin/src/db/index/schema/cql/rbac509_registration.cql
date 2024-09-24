-- Index of RBAC 509 registrations. Valid. 
CREATE TABLE IF NOT EXISTS RBAC509_registration (
    -- Primary Key Data
    chain_root          blob,           -- 32 Bytes of Chain Root.
    slot_no             varint,         -- slot number when the key_was_registered.
    txn                 smallint,       -- Index of the TX which holds the registration data.
    transaction_id      blob,           -- 32 Bytes of Transaction Hash.
    purpose             blob,           -- 16 Bytes of UUIDv4 Purpose.

    -- Non-Key Data
    prv_txn_id          blob,           -- 32 Bytes from Previous Transaction Hash.

    PRIMARY KEY (chain_root, slot_no, txn, transaction_id, purpose)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn DESC);
