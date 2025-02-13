-- Get all primary keys from CIP-36 registration.
SELECT
    stake_address,
    nonce,
    slot_no,
    txn_index
FROM cip36_registration
