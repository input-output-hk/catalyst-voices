-- Create the TXO Record for a stake address, 
-- Will not overwrite anything if it already exists.
UPDATE txo_assets_by_stake SET
    value = :value,
    txn_hash = :txn_hash
WHERE 
    stake_address = :stake_address AND
    slot_no = :slot_no AND 
    txn = :txn AND 
    txo = :txo AND 
    policy_id = :policy_id AND
    policy_name = :policy_name ;
