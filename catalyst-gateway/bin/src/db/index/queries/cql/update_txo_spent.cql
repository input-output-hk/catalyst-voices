-- Update TXO Spent by the stake address
UPDATE txo_by_stake
    SET spent_slot = :spent_slot
WHERE stake_address = :stake_address
    AND txn_index = :txn_index
    AND txo = :txo
    AND slot_no = :slot_no
