-- Index of RBAC 509 registrations. Valid. 
CREATE TABLE IF NOT EXISTS rbac_registration (
    -- Primary Key Data
    catalyst_id         text,           -- Short Catalyst id
    txn_id              blob,           -- 32 Bytes of Transaction Hash. (TransactionHash)

    -- Non-Key Data
    slot_no             varint,         -- slot number of the txn_id. (u64)
    txn_index           smallint,       -- Index of the TX which holds the registration data. (i16)
    prv_txn_id          blob,           -- 32 Bytes from Previous Transaction Hash.
    purpose             uuid,           -- 16 Bytes of UUIDv4 Purpose.

    PRIMARY KEY (catalyst_id, txn_id)
)
WITH CLUSTERING ORDER BY (txn_id DESC);
