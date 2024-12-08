-- Index of Chain Root For Role0 Key. RBAC 509 registrations. 
CREATE TABLE IF NOT EXISTS rbac_chain_root_for_role0_kid (
    -- Primary Key Data
    role0_kid           blob,       -- 16 Bytes of Role0 Key. (Role0Kid)
    slot_no             varint,     -- slot number when the key_was_registered. (u64)
    txn                 smallint,   -- Index of the TX which holds the registration data. (i16)

    -- Non-Key Data
    chain_root          blob,       -- 32 Bytes of Chain Root. (TransactionHash)
    chain_root_slot     varint,     -- Slot number the chain root can be found in
    chain_root_txn      smallint    -- Index of the tx which holds the chain root.

    signature_alg       text        -- Signature Algorithm used by the Certificate
    public_key          blob        -- Public Key of the Role0 Certificate. (PublicKey)

    PRIMARY KEY (role0_kid, slot_no, txn)
)
WITH CLUSTERING ORDER BY (slot_no DESC, txn DESC);
