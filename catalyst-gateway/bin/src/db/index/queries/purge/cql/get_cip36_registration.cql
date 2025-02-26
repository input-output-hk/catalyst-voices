-- Get all primary keys from CIP-36 registration.
SELECT
    stake_public_key,
    nonce,
    slot_no,
    txn_index
FROM cip36_registration
