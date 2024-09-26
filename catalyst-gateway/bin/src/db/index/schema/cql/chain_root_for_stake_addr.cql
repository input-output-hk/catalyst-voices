-- Index of Chain Root For Stake Address. RBAC 509 registrations.
CREATE TABLE IF NOT EXISTS chain_root_for_stake_addr (
    -- Primary Key Data
    stake_addr          blob,       -- 32 Bytes of Stake Address.
    slot_no             varint,     -- slot number when the key_was_registered.
    txn                 smallint,   -- Index of the TX which holds the registration data.
    chain_root          blob,       -- 32 Bytes of Chain Root.

    PRIMARY KEY (stake_addr, slot_no, txn)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn DESC);
