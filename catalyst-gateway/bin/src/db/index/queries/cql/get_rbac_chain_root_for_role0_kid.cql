SELECT  
    slot_no, 
    txn, 
    chain_root,
    chain_root_slot,
    chain_root_txn,
    signature_alg,
    public_key
FROM 
    rbac_chain_root_for_role0_kid
WHERE 
    role0_kid = :role0_kid
