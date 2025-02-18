SELECT
    txn_id,
    txn_index,
    txo,
    slot_no,
    value,
    spent_slot
FROM txo_by_stake
WHERE stake_address = :stake_address
AND slot_no <= :slot_no
