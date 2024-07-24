-- Transaction Outputs (Native Assets) per stake address.
-- Unstaked ADA address is an empty string.
CREATE TABLE IF NOT EXISTS txo_assets_by_stake (
    -- Priamry Key Fields
    stake_address   ascii,    -- stake address (CIP19 Formatted Text)
    slot_no         bigint,   -- slot number the txo was created in.
    txn             smallint, -- Which Transaction in the Slot is the TXO.
    txo_index       smallint, -- offset in the txo list of the transaction the txo is in.
    policy_hash     ascii,    -- asset policy hash (Hex Encoded Hash)
    policy_id       ascii,    -- id of the policy

    policy_name     text,     -- name of the policy (UTF8)
    value           varint,   -- Value of the asset (u64)

    -- Data needed to correlate a spent TXO.
    txn_hash        blob,       -- 32 byte hash of this transaction.

    spent_slot      varint,     -- Slot this TXO was spent in.
                                -- This is ONLY calculated/stored 
                                -- when first detected in a query lookup.
                                -- It serves as an optimization on subsequnt queries. 

    PRIMARY KEY (stake_address, slot_no, txn, ofs, policy_hash, policy_id)
);
