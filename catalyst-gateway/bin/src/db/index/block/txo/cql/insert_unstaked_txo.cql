-- Create the TXO Record for when its not staked. 
INSERT INTO unstaked_txo_by_txn_hash (
    txn_hash,
    txo,
    slot_no,
    txn,
    address,
    value
) VALUES (
    :txn_hash,
    :txo,
    :slot_no,
    :txn,
    :address,
    :value
);
