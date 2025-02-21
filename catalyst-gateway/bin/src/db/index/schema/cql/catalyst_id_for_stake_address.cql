-- Index of Catalyst ID For Stake Address. RBAC 509 registrations.
CREATE TABLE IF NOT EXISTS catalyst_id_for_stake_address (
    -- Primary Key Data
    stake_address       blob,       -- 29 Byte stake hash (CIP19)

    -- Non-Key Data
    catalyst_id         text,       -- Catalyst Short ID
    slot_no             varint,     -- slot number of the txn_id. (u64)

    PRIMARY KEY (stake_address)
)
