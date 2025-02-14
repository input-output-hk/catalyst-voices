SELECT  
    slot_no, 
    txn_index,
    catalyst_id
FROM 
    catalyst_id_for_stake_hash
WHERE 
    stake_hash = :stake_hash
