-- Create the TXI Record for a transaction hash, 
INSERT INTO txi_by_txn_id (
    txn_id,
    txo,
    slot_no
) VALUES (
   :txn_id,
   :txo, 
   :slot_no
);
