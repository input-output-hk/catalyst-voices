-- Index of Chain Root For Stake Address. RBAC 509 registrations.
CREATE TABLE IF NOT EXISTS rbac_chain_root_for_stake_addr (
    -- Primary Key Data
    stake_addr          blob,       -- 29 Byte Stake Address (CIP19)
    slot_no             varint,     -- slot number when the key_was_registered. (u64)
    txn                 smallint,   -- Index of the TX which holds the registration data. (i16)
    chain_root          blob,       -- 32 Bytes of Chain Root. (TransactionHash)

    PRIMARY KEY (stake_addr, slot_no, txn)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn DESC);
