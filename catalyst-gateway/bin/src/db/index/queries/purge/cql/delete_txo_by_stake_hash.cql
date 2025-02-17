-- Delete Transaction Output by Stake Address.
DELETE FROM txo_by_stake
WHERE stake_hash = :stake_hash
    AND slot_no = :slot_no
    AND txn_index = :txn_index
    AND txo = :txo
