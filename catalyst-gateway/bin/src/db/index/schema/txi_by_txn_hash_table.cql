-- This could be ADA or a native asset being spent.
-- This can represent a spend on either immutable data or volatile data.
CREATE TABLE IF NOT EXISTS txi_by_txn_hash (
    txn_hash        blob,     -- 32 Bytes Transaction Hash that was spent.
    txo             smallint, -- Index of the TXO which was spent
    slot_no         varint,   -- slot number when the spend occured. 
                
    PRIMARY KEY (txn_hash, txo_index, slot_no)
);
