-- Index of Chain Root For TX ID (RBAC 509 registrations).
CREATE TABLE IF NOT EXISTS chain_root_for_txn_id (
    -- Primary Key Data
    transaction_id      blob,   -- 32 Bytes of Transaction Hash.

    -- Non-Key Data
    chain_root          blob,   -- 32 Bytes of Chain Root.

    PRIMARY KEY (transaction_id)
);
