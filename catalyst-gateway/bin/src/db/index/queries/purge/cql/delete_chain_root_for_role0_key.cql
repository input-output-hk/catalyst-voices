-- Delete Chain Root For Role0 Key (RBAC 509 registrations).
DELETE FROM chain_root_for_role0_key
WHERE role0_key = :role0_key
    AND slot_no = :slot_no
    AND txn = :txn
