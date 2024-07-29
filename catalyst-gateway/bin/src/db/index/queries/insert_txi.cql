-- Create the TXI Record for a transaction hash, 
-- But only if it does not already exist.
INSERT INTO txi_by_txn_hash (
    txn_hash, 
    txo, 
    slot_no) 
VALUES(?, ?, ?) 
IF NOT EXISTS;