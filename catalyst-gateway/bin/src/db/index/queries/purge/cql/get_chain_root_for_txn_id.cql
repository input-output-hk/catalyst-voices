-- Get all primary keys from Chain Roots for a Role0 Key.
SELECT
    role0_key,
    slot_no,
    txn
FROM chain_root_for_role0_key
