SELECT  
    slot_no, 
    txn, 
    chain_root,
    chain_root_slot,
    chain_root_txn
FROM 
    rbac_chain_root_for_stake_addr
WHERE 
    stake_addr = :stake_address
