-- Transaction Outputs (Native Assets) per stake address.
-- Unstaked Assets are not present in this table.
CREATE TABLE IF NOT EXISTS txo_assets_by_stake (
    -- Primary Key Fields
    stake_address   blob,     -- 29 Byte stake address (CIP19).
    slot_no         varint,   -- slot number the txo was created in.
    txn_index       smallint, -- Which Transaction in the Slot is the TXO.
    txo             smallint, -- offset in the txo list of the transaction the txo is in.
    policy_id       blob,     -- asset policy hash (id) (28 byte binary hash)
    asset_name      blob,     -- name of the asset policy (UTF8) (0 - 32 bytes)


    -- None Key Data of the asset.
    value           varint,   -- Value of the asset (i128)

    PRIMARY KEY (stake_address, slot_no, txn_index, txo, policy_id, asset_name)
);
