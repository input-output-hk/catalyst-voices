-- Index of stake registrations.
-- Can also be used to convert a known stake key hash back to a full stake address.
CREATE TABLE IF NOT EXISTS stake_registration (
    -- Primary Key Data
    stake_address    blob,     -- 29 Byte stake hash (CIP19).
    slot_no          varint,   -- slot number when the key_was_registered/re-registered.
    txn_index        smallint, -- Index of the TX which holds the registration data.

    -- Non-Key Data
    stake_public_key blob,     -- 32 Bytes Stake address - not present for scripts and may not be present for `register`.

    -- Stake key lifecycle data, shows what happened with the stake key at this slot#.
    script           boolean,  -- Is the address a script address.
    register         boolean,  -- True if the this transaction contains cardano stake registration cert.
    deregister       boolean,  -- True if the this transaction contains cardano stake deregistration cert.
    cip36            boolean,  -- True if the this transaction contains CIP36 registration.
    pool_delegation  blob,     -- Stake was delegated to this Pool address.
                              -- Not present if delegation did not change.

    PRIMARY KEY (stake_address, script, slot_no, txn_index)
);
