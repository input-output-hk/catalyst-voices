-- Delete CIP-36 registration.
DELETE FROM cip36_registration
WHERE stake_address = :stake_address
    AND nonce = :nonce
    AND slot_no = :slot_no
    AND txn = :txn
