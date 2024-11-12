-- Get all primary keys from chain roots for a role0 key.
SELECT
    role0_key,
    slot_no,
    txn
FROM chain_root_for_role0_key
