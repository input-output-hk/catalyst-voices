SELECT  
    stake_address
FROM 
    catalyst_id_for_stake_address
WHERE 
    catalyst_id = :catalyst_id
ALLOW FILTERING;