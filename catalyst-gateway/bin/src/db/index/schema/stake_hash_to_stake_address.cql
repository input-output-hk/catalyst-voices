-- This could be ADA or a native asset being spent.
-- This can represent a spend on either immutable data or volatile data.
CREATE TABLE IF NOT EXISTS stake_hash_to_stake_address (
    -- Primary Key Data
    stake_hash      blob,     -- 32 Bytes Stake Key Hash.
    slot_no         varint,   -- slot number when the key_was_registered.
    txn             smallint, -- Index of the TX which washolds the registration
    
    -- Non key data, we can only spend a transaction hash/txo once, so this should be unique in any event.
    stake_address   blob,     -- 32 Bytes Stake address - not present for scripts

    register        boolean,  -- True if the stake was registered in this transaction.
    deregister      boolean,  -- True if the stake key was deregisterd in this transaction.
    pool_delegation blob,     -- Stake was delegated to this Pool address.

    PRIMARY KEY (stake_hash, slot_no, txn)
);
