-- Transaction Outputs (Native Assets) per stake address.
-- Unstaked ADA address is an empty string.
CREATE TABLE IF NOT EXISTS txo_assets_by_stake (
    -- Priamry Key Fields
    stake_address   blob,     -- stake address hash (28 bytes stake address hash, zero length if not staked.)
    slot_no         varint,   -- slot number the txo was created in.
    txn             smallint, -- Which Transaction in the Slot is the TXO.
    txo             smallint, -- offset in the txo list of the transaction the txo is in.
    policy_id       blob,     -- asset policy hash (id) (28 byte binary hash)
    policy_name     text,     -- name of the policy (UTF8)

    -- None Key Data of the asset.
    value           varint,   -- Value of the asset (u64)

    -- Data needed to correlate a spent TXO.
    txn_hash        blob,       -- 32 byte hash of this transaction.

    spent_slot      varint,     -- Slot this TXO was spent in.
                                -- This is ONLY calculated/stored 
                                -- when first detected in a query lookup.
                                -- It serves as an optimization on subsequnt queries. 
                                -- It is also only updated when the refenc is the same type
                                -- ie, an immutable txo can only record an immutable spend.

    PRIMARY KEY (stake_address, slot_no, txn, txo, policy_id, policy_name)
);
