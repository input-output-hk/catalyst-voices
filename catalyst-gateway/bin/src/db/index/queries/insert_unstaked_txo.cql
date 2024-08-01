-- Create the TXO Record for a stake address, 
-- But nlyif it does not already exist.
UPDATE txo_by_stake SET
    address = :address,
    value = :value,
    txn_hash = :txn_hash
WHERE 
    stake_address = :stake_address AND 
    slot_no = :slot_no AND 
    txn = :txn and 
    txo = :txo ;
