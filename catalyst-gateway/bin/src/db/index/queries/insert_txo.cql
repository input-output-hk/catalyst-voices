-- Create the TXO Record for a stake address,
INSERT INTO txo_by_stake (
    stake_address,
    slot_no,
    txn,
    txo,
    address,
    value,
    txn_hash,
    spent_slot
) VALUES (
    :stake_address,
    :slot_no,
    :txn,
    :txo,
    :address,
    :value,
    :txn_hash,
    :spent_slot
);
