-- Delete Stake Registration.
DELETE FROM stake_registration
WHERE stake_address = :stake_address
    AND script = :script
    AND slot_no = :slot_no
    AND txn_index = :txn_index
