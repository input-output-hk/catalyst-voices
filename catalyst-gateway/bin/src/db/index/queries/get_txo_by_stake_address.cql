SELECT
    txn_hash,
    txn,
    txo,
    slot_no,
    value
FROM txo_by_stake
WHERE stake_address = :stake_address
AND slot_no <= :slot_no
AND spent_slot = -1
ALLOW FILTERING
