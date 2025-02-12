-- Index of Chain Root For TX ID. RBAC 509 registrations. 
CREATE TABLE IF NOT EXISTS catalyst_id_for_txn_id (
    -- Primary Key Data
    transaction_id      blob,       -- 32 Bytes of Transaction Hash. (TransactionHash)

    -- Non-Key Data
    catalyst_id         text,       -- Short catalyst ID
    slot_no             bigint,     -- Slot number when the key_was_registered. (u64)
    txn_idx             smallint,   -- Index of the TX which holds the registration data. (i16)

    PRIMARY KEY (transaction_id)
);
