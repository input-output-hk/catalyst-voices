-- Index of Catalyst ID For Stake Address. RBAC 509 registrations.
CREATE TABLE IF NOT EXISTS catalyst_id_for_stake_address (
    -- Primary Key Data
    stake_address       blob,       -- 29 Byte stake hash (CIP19)
    slot_no             varint,     -- slot number of the txn_id. (u64)
    txn_index           smallint,   -- Index of the TX which holds the registration data. (i16)

    -- Non-Key Data
    catalyst_id         text,       -- Catalyst Short ID

    PRIMARY KEY (stake_address, slot_no, txn_index)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn_index DESC);
