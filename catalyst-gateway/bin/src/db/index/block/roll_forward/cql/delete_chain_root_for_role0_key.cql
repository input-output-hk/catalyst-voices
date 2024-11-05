-- Delete all the chain roots for a role0 key
DELETE FROM chain_root_for_role0_key
WHERE role0_key = :role0_key
    AND slot_no = :slot_no
    AND txn = :txn
