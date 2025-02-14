-- Delete invalid CIP-36 registration.
DELETE FROM cip36_registration_invalid
WHERE stake_public_key = :stake_public_key
    AND slot_no = :slot_no
    AND txn_index = :txn_index
