-- Index of CIP-509 registrations. Valid. 
CREATE TABLE IF NOT EXISTS cip509_registration (
    -- Primary Key Data
    vote_key            blob,           -- 32 Bytes of Vote Key.
    stake_address       blob,           -- 32 Bytes of Stake Address.
    nonce               varint,         -- Nonce that has been slot corrected.
    slot_no             varint,         -- slot number when the key_was_registered/re-registered.
    txn                 smallint,       -- Index of the TX which holds the registration data.

    -- Non-Key Data
    purpose                 blob,       -- 16 Bytes of UUIDv4 Purpose.
    txn_inputs_hash         blob,       -- 16 Bytes of TX inputs hash.
    prv_txn_id              blob,
    -- WIP: what data is relevant for indexing
    -- x509_chunks             list<blob>, -- x509 chunks.
    validation_signature    blob,       -- Validation signature.

    PRIMARY KEY ((vote_key, stake_address), nonce, slot_no, txn)
)
WITH CLUSTERING ORDER BY (nonce DESC, slot_no DESC, txn DESC);
