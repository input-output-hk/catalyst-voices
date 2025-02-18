SELECT  
    slot_no, 
    txn_index,
    catalyst_id
FROM 
    catalyst_id_for_stake_address
WHERE 
    stake_address = :stake_address
