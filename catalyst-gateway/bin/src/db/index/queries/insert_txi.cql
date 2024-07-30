-- Create the TXI Record for a transaction hash, 
UPDATE txi_by_txn_hash SET
    slot_no = :slot_no
WHERE    
    txn_hash = :txn_hash AND 
    txo = :txo ;