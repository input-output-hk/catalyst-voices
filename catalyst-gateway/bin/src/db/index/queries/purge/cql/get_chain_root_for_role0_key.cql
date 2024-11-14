-- Get all primary keys from Chain Root For Role0 Key (RBAC 509 registrations).
SELECT
    role0_key,
    slot_no,
    txn
FROM chain_root_for_role0_key
