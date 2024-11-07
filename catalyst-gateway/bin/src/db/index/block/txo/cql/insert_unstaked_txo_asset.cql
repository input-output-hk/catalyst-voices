-- Create the TXO Record for an unstaked TXO Asset. 
INSERT INTO unstaked_txo_assets_by_txn_hash (
    txn_hash,
    txo,
    policy_id,
    asset_name,
    slot_no,
    txn,
    value
) VALUES (
   :txn_hash, 
   :txo, 
   :policy_id, 
   :asset_name,
   :slot_no,
   :txn,
   :value
);
