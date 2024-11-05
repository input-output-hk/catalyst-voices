-- Transaction Outputs (Native Assets) per stake address.
-- Unstaked Assets are not present in this table.
CREATE TABLE IF NOT EXISTS txo_assets_by_stake (
    -- Primary Key Fields
    stake_address   blob,     -- stake address hash (28 bytes stake address hash, zero length if not staked.)
    slot_no         varint,   -- slot number the txo was created in.
    txn             smallint, -- Which Transaction in the Slot is the TXO.
    txo             smallint, -- offset in the txo list of the transaction the txo is in.
    asset_id        blob,     -- asset policy hash (id) (28 byte binary hash)
    asset_name      text,     -- name of the asset policy (UTF8) (32 bytes)


    -- None Key Data of the asset.
    value           varint,   -- Value of the asset (i128)

    PRIMARY KEY (stake_address, slot_no, txn, txo, asset_id, asset_name)
);
