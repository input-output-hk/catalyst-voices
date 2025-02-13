-- Index of CIP-36 registrations. Valid. 
CREATE TABLE IF NOT EXISTS cip36_registration (
    -- Primary Key Data
    stake_address       blob,       -- 32 Bytes of Stake Address.
    nonce               varint,     -- Nonce that has been slot corrected.
    slot_no             bigint,     -- slot number when the key_was_registered/re-registered.
    txn_index           smallint,   -- Index of the TX which holds the registration data.

    -- Non-Key Data
    vote_key            blob,       -- 32 Bytes of Vote Key.
    payment_address     blob,       -- Bytes of address for payment of rewards.
    is_payable          boolean,    -- True if payment to the address is possible.
    raw_nonce           varint,     -- Nonce that has not been slot corrected.
    cip36               boolean,    -- True if the registration is CIP-36 format, Cip-15=False.

    PRIMARY KEY (stake_address, nonce, slot_no, txn_index)
)
WITH CLUSTERING ORDER BY (nonce DESC, slot_no DESC, txn_index DESC);
