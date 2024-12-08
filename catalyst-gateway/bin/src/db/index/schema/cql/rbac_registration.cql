-- Index of RBAC 509 registrations. Valid. 
CREATE TABLE IF NOT EXISTS rbac_registration (
    -- Primary Key Data
    chain_root          blob,           -- 32 Bytes of Chain Root. (TransactionHash)
    transaction_id      blob,           -- 32 Bytes of Transaction Hash. (TransactionHash)
    slot_no             varint,         -- slot number of the transaction_id. (u64)
    txn                 smallint,       -- Index of the TX which holds the registration data. (i16)

    -- Non-Key Data
    prv_txn_id          blob,           -- 32 Bytes from Previous Transaction Hash.
    purpose             uuid,           -- 16 Bytes of UUIDv4 Purpose.

    PRIMARY KEY (chain_root, transaction_id, slot_no, txn)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn DESC);
