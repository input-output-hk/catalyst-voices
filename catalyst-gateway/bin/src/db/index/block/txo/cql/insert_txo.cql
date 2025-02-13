-- Create the TXO Record for a stake address,
INSERT INTO txo_by_stake (
    stake_key_hash,
    slot_no,
    txn_index,
    txo,
    address,
    value,
    txn_id
) VALUES (
    :stake_key_hash,
    :slot_no,
    :txn_index,
    :txo,
    :address,
    :value,
    :txn_hash
);
