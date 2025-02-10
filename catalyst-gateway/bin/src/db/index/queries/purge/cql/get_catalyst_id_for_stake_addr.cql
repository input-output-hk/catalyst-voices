-- Get all primary keys from Catalyst ID For Stake Address (RBAC 509 registrations).
SELECT
    stake_addr,
    slot_no,
    txn
FROM catalyst_id_for_stake_addr
