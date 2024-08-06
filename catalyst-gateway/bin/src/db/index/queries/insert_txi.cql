-- Create the TXI Record for a transaction hash, 
INSERT INTO txi_by_txn_hash (
    txn_hash,
    txo,
    slot_no
) VALUES (
   :txn_hash, 
   :txo, 
   :slot_no
);
