-- Transaction Outputs (ADA) per stake address.
-- Unstaked ADA is not present in this table.
CREATE TABLE IF NOT EXISTS txo_by_stake (
    -- Primary Key Fields
    stake_key_hash  blob,       -- stake address hash (28 bytes stake address hash, zero length if not staked.)
    slot_no         varint,     -- slot number the txo was created in.
    txn_index       smallint,   -- Which Transaction in the Slot is the TXO.
    txo             smallint,   -- offset in the txo list of the transaction the txo is in.

    -- Transaction Output Data
    address         ascii,      -- TXO address (CIP19 Formatted Text).
    value           varint,     -- Lovelace value of the TXO (u64).
    
    -- Data needed to correlate a spent TXO.
    txn_id          blob,       -- 32 byte hash of this transaction.

    spent_slot      varint,     -- Slot this TXO was spent in.
                                -- This is ONLY calculated/stored 
                                -- when first detected in a query lookup.
                                -- It serves as an optimization on subsequent queries. 

    PRIMARY KEY (stake_key_hash, slot_no, txn_index, txo)
);
