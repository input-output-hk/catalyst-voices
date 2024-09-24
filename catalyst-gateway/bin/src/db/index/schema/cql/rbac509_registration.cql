-- Index of RBAC 509 registrations. Valid. 
CREATE TABLE IF NOT EXISTS rbac509_registration (
    -- Primary Key Data
    chain_root          blob,           -- 32 Bytes of Chain Root.
    transaction_id      blob,           -- 32 Bytes of Transaction Hash.
    purpose             blob,           -- 16 Bytes of UUIDv4 Purpose.
    slot_no             varint,         -- slot number when the key_was_registered/re-registered.
    txn                 smallint,       -- Index of the TX which holds the registration data.

    -- Non-Key Data
    prv_txn_id          blob,           -- 32 Bytes from Previous Transaction Hash.

    PRIMARY KEY (chain_root, transaction_id, purpose, slot_no, txn)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn DESC);
