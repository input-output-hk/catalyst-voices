-- Delete Stake Registration.
DELETE FROM stake_registration
WHERE stake_key_hash = :stake_key_hash
    AND script = :script
    AND slot_no = :slot_no
    AND txn_index = :txn_index
