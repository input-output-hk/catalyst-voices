-- Transaction Outputs (ADA) that are not staked, by their transaction hash.
CREATE TABLE IF NOT EXISTS unstaked_txo_by_txn_hash (
    -- Primary Key Fields
    txn_hash        blob,       -- 32 byte hash of this transaction.
    txo             smallint,   -- offset in the txo list of the transaction the txo is in.

    -- Secondary Location information for the transaction.
    slot_no         bigint,     -- slot number the txo was created in.
    txn             smallint,   -- Which Transaction in the Slot is the TXO.


    -- Transaction Output Data
    address         ascii,      -- TXO address (CIP19 Formatted Text).
    value           varint,     -- Lovelace value of the TXO (u64).

    spent_slot      bigint,     -- Slot this TXO was spent in.
                                -- This is ONLY calculated/stored 
                                -- when first detected in a query lookup.
                                -- It serves as an optimization on subsequent queries. 

    PRIMARY KEY (txn_hash, txo)
);
