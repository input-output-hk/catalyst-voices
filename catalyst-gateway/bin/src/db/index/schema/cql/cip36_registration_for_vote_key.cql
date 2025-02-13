-- Index of CIP-36 registrations searchable by Stake Address.
-- Full registration data needs to be queried from the main cip36 registration tables.
-- Includes both Valid and Invalid registrations.
CREATE TABLE IF NOT EXISTS cip36_registration_for_vote_key (
    -- Primary Key Data
    vote_key            blob,       -- 32 Bytes of Vote Key.
    stake_address       blob,       -- 32 Bytes of Stake Address.
    slot_no             varint,     -- slot number when the key_was_registered/re-registered.
    txn_index           smallint,   -- Index of the TX which holds the registration data.
    valid               boolean,    -- True if the registration is valid.

    PRIMARY KEY ((vote_key, stake_address), slot_no, txn_index, valid)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn_index DESC);
