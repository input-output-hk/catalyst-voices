-- Delete CIP-36 registration.
DELETE FROM cip36_registration
WHERE stake_public_key = :stake_public_key
    AND nonce = :nonce
    AND slot_no = :slot_no
    AND txn_index = :txn_index
