-- Get all primary keys from Chain Root For Stake Address (RBAC 509 registrations).
SELECT
    stake_addr,
    slot_no,
    txn
FROM chain_root_for_stake_addr
