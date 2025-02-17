-- Create the TXO Record for a stake address, 
-- Will not overwrite anything if it already exists.
INSERT INTO txo_assets_by_stake (
    stake_hash,
    slot_no,
    txn_index,
    txo,
    policy_id,
    asset_name,
    value
) VALUES (
    :stake_hash,
    :slot_no,
    :txn_index,
    :txo,
    :policy_id,
    :asset_name,
    :value 
);
