-- Delete invalid CIP-36 registration.
DELETE FROM cip36_registration_invalid
WHERE stake_address = :stake_address
    AND slot_no = :slot_no
    AND txn = :txn
