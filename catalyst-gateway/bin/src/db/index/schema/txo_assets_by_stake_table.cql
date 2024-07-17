-- Transaction Outputs (Native Assets) per stake address.
-- Unstaked ADA address is an empty string.
CREATE TABLE IF NOT EXISTS txo_assets_by_stake (
    -- Priamry Key Fields
    stake_address   ascii,    -- stake address (CIP19 Formatted Text)
    slot_no         bigint,   -- slot number the txo was created in.
    txn             smallint, -- Which Transaction in the Slot is the TXO.
    ofs             smallint,   -- offset in the txo list of the transaction the txo is in.
    policy_hash     ascii,    -- asset policy hash (Hex Encoded Hash)
    policy_id       ascii,    -- id of the policy

    policy_name     text,     -- name of the policy (UTF8)
    value           varint,   -- Value of the asset (u64)

    -- stake_address should be unique, this is for the unlikely case we need disambiguation only.
    chain           ascii,    -- chain the txo was created in (stake_address should be unique, this is for disambiguation only).

    -- Transaction Spend details. Only ever present in the persistent data.
    spend_slot   bigint,        -- slot number the txo was spent in.
    spend_txn    smallint,      -- transaction number the txo was spent in.
    spend_ofs    smallint,      -- offset in the transaction inputs the txo was spent in.

    PRIMARY KEY (stake_address, slot_no, txn, ofs, policy_hash, policy_id)
);
