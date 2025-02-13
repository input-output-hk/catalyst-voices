SELECT
    txn_id,
    txn_index,
    txo,
    slot_no,
    value,
    spent_slot
FROM txo_by_stake
WHERE stake_key_hash = :stake_key_hash
AND slot_no <= :slot_no
