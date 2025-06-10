-- Index of Catalyst ID for public key. RBAC 509 registrations.
CREATE TABLE IF NOT EXISTS catalyst_id_for_public_key (
    -- Primary Key Data
    public_key          blob,       -- 32 Bytes of public key.

    -- Non-Key Data
    catalyst_id         text,       -- Catalyst Short ID
    slot_no             varint,     -- slot number of the txn_id. (u64)

    PRIMARY KEY (public_key)
);
