-- Get all primary keys from Catalyst ID For Stake Address (RBAC 509 registrations).
SELECT
    stake_hash,
    slot_no,
    txn_index
FROM catalyst_id_for_stake_hash
