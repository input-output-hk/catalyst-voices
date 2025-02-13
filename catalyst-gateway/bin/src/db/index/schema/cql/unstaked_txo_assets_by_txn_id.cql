-- Transaction Outputs (Native Assets) by their transaction hash.
CREATE TABLE IF NOT EXISTS unstaked_txo_assets_by_txn_id (
    -- Primary Key Fields
    txn_id          blob,     -- 32 byte hash of this transaction.
    txo             smallint, -- offset in the txo list of the transaction the txo is in.
    policy_id       blob,     -- asset policy hash (id) (28 byte binary hash)
    asset_name      blob,     -- name of the policy (UTF8) (32 bytes)

    -- Secondary Location information for the transaction.
    slot_no         bigint,     -- slot number the txo was created in.
    txn_index       smallint,   -- Which Transaction in the Slot is the TXO.

    -- Value of the asset.
    value           varint,   -- Value of the asset (u64)

    PRIMARY KEY (txn_id, txo, policy_id, asset_name)
);
