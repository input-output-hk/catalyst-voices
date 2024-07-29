-- Create the TXO Record for a stake address, 
-- But only if it does not already exist.
INSERT INTO txo_by_stake (
    stake_address, 
    slot_no, 
    txn, 
    txo, 
    policy_id,
    policy_name,
    value,
    txn_hash) 
VALUES(?, ?, ?, ?, ?, ?, ?, ?) 
IF NOT EXISTS;