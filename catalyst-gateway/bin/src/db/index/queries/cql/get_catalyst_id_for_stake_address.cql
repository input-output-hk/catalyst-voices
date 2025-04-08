SELECT  
    catalyst_id,
    slot_no
FROM 
    catalyst_id_for_stake_address
WHERE 
    stake_address = :stake_address
