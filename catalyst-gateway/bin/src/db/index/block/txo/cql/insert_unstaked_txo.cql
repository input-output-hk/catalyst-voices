-- Create the TXO Record for when its not staked. 
INSERT INTO unstaked_txo_by_txn_id (
    txn_id,
    txo,
    slot_no,
    txn_index,
    address,
    value
) VALUES (
    :txn_id,
    :txo,
    :slot_no,
    :txn_index,
    :address,
    :value
);
