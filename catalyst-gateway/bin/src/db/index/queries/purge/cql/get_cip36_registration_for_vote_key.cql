-- Get all primary keys from CIP-36 registration by Vote Key.
SELECT
    vote_key,
    stake_address,
    slot_no,
    txn,
    valid
FROM cip36_registration_for_vote_key
