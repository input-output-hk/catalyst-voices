-- Index of Catalyst ID for TX ID. RBAC 509 registrations.
CREATE TABLE IF NOT EXISTS catalyst_id_for_txn_id (
    -- Primary Key Data
    txn_id              blob,       -- 32 Bytes of Transaction Hash. (TransactionHash)

    -- Non-Key Data
    catalyst_id         text,       -- Short catalyst ID
    slot_no             varint,     -- slot number of the txn_id. (u64)

    PRIMARY KEY (txn_id)
);
