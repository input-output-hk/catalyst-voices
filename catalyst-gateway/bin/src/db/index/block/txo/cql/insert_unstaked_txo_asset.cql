-- Create the TXO Record for an unstaked TXO Asset. 
INSERT INTO unstaked_txo_assets_by_txn_id (
    txn_id,
    txo,
    policy_id,
    asset_name,
    slot_no,
    txn_index,
    value
) VALUES (
   :txn_id,
   :txo, 
   :policy_id, 
   :asset_name,
   :slot_no,
   :txn_index,
   :value
);
