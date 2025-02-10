SELECT  
    slot_no, 
    txn, 
    catalyst_id
FROM 
    catalyst_id_for_stake_addr
WHERE 
    stake_addr = :stake_address
