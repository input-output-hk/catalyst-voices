-- Transaction Outputs (Native Assets) per stake address.
CREATE TABLE IF NOT EXISTS unstaked_txo_assets_by_txn_hash (
    -- Priamry Key Fields
    txn_hash        blob,     -- 32 byte hash of this transaction.
    txo             smallint, -- offset in the txo list of the transaction the txo is in.
    policy_id       blob,     -- asset policy hash (id) (28 byte binary hash)
    policy_name     text,     -- name of the policy (UTF8)

    -- Secondary location information
    slot_no         varint,   -- slot number the txo was created in.
    txn             smallint, -- Which Transaction in the Slot is the TXO.

    -- Value of the asset.
    value           varint,   -- Value of the asset (u64)

    -- Data needed to correlate a spent TXO.
    spent_slot      varint,     -- Slot this TXO was spent in.
                                -- This is ONLY calculated/stored 
                                -- when first detected in a query lookup.
                                -- It serves as an optimization on subsequnt queries. 
                                -- It is also only updated when the refenc is the same type
                                -- ie, an immutable txo can only record an immutable spend.

    PRIMARY KEY (txn_hash, txo, policy_id, policy_name)
);
