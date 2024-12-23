-- Index of Chain Root For TX ID. RBAC 509 registrations. 
CREATE TABLE IF NOT EXISTS rbac_chain_root_for_txn_id (
    -- Primary Key Data
    transaction_id      blob,       -- 32 Bytes of Transaction Hash. (TransactionHash)

    -- Non-Key Data
    chain_root          blob,       -- 32 Bytes of Chain Root. (TransactionHash)
    slot_no             varint,     -- slot number of the Chain Root. (u64)
    txn_idx             smallint,   -- Index of the TX which holds the Chain Root. (i16)

    PRIMARY KEY (transaction_id)
);
