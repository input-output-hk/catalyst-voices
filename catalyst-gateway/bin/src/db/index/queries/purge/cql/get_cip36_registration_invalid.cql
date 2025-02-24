-- Get all primary keys from CIP-36 Invalid Registration by Stake Address.
SELECT
    stake_public_key,
    slot_no,
    txn_index
FROM cip36_registration_invalid
