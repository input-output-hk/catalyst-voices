-- Get all primary keys from CIP-36 invalid registration by Stake Address.
SELECT
    stake_address,
    slot_no,
    txn,
FROM cip36_registration_invalid
