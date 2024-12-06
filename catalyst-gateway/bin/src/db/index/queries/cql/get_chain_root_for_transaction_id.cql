SELECT 
    chain_root,
    slot_no,
    txn_idx
FROM 
    chain_root_for_txn_id
WHERE 
    transaction_id = :transaction_id
