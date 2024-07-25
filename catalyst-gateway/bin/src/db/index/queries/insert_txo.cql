-- Create the TXO Record for a stake address, 
-- But nlyif it does not already exist.
INSERT INTO txo_by_stake (
    stake_address, 
    slot_no, 
    txn, 
    txo, 
    address, 
    value,
    txn_hash,) 
VALUES(?, ?, ?, ?, ?, ?, ?) 
IF NOT EXISTS;