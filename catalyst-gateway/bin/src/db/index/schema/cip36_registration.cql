-- Index of CIP-36 registrations by stake address.
CREATE TABLE IF NOT EXISTS cip36_registration_by_stake_address (
    -- Primary Key Data
    stake_address       blob,       -- 32 Bytes of Stake Address.
    vote_key            blob,       -- 32 Bytes of Vote Key.
    slot_no             varint,     -- slot number when the key_was_registered/re-registered.
    txn                 smallint,   -- Index of the TX which holds the registration data.

    -- Non-Key Data
    payment_address     blob,       -- Bytes of address for payment of rewards.
    is_payable          boolean,    -- True if payment to the address is possible.
    raw_nonce           varint,     -- Nonce that has not been slot corrected.
    nonce               varint,     -- Nonce that has been slot corrected.
    purpose             varint,     -- Registration Purpose (Always 0 for Catalyst).
    signed              boolean,    -- Signature validates.
    strict_catalyst     boolean,    -- Strict Catalyst validated.
    error_report        list<text>, -- List of serialization errors in the registration.

    PRIMARY KEY (stake_address, vote_key, slot_no, txn)
)
WITH CLUSTERING ORDER BY (vote_key ASC, slot_no DESC, txn DESC);
